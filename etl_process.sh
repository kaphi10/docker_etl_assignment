# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo ".env file not found! Creating a template .env file..."
    cat > .env << EOF
# Database Configuration
DB_NAME=etl_database
DB_USER=postgres
DB_PASSWORD=etl_password
DB_HOST=postgres-container
DB_PORT=5432
DB_TABLE=baby_names

EOF
    echo "Please edit the .env file with your actual values and run the script again."
    exit 1
fi
#Load environment variables
set -a
source .env
set +a

# Validate required environment variables
required_vars=("DB_NAME" "DB_USER" "DB_PASSWORD" "DB_TABLE")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        print "Required environment variable $var is not set in .env file"
        exit 1
    fi
done

# Stop and remove existing containers if they exist
echo "Cleaning up existing containers..."
docker stop etl-container postgres-container > /dev/null 2>&1 || true
docker rm etl-container postgres-container > /dev/null 2>&1 || true

# Remove existing network if it exists
docker network rm etl-network > /dev/null 2>&1 || true

# Create Docker network
echo "Creating Docker network..."
docker network create etl-network
echo "Docker network 'etl-network' created successfully"

# Start PostgreSQL container
echo "Starting PostgreSQL container..."
docker run -d \
    --name postgres-container \
    --network etl-network \
    -e POSTGRES_DB=$DB_NAME \
    -e POSTGRES_USER=$DB_USER \
    -e POSTGRES_PASSWORD=$DB_PASSWORD \
    -p 5432:5432 \
    -v postgres_data:/var/lib/postgresql/data \
    postgres:13

echo "PostgreSQL container started successfully"


echo "Building ETL application image..."
docker build -t etl-app .
echo "ETL application image built successfully"

# Run ETL container
echo "Running ETL process..."
docker run \
    --name etl-container \
    --network etl-network \
    -e DB_HOST=postgres-container \
        etl-app
   
    
# Check if ETL process was successful
ETL_EXIT_CODE=$?
if [ $ETL_EXIT_CODE -eq 0 ]; then
    echo "ETL process completed successfully!"
fi
