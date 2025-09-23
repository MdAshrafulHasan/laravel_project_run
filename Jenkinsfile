pipeline {
    agent any

    environment {
        DB_CONNECTION = "mysql"
        DB_HOST = "laravel_db"
        DB_PORT = "3306"
        DB_DATABASE = "laravel"
        DB_USERNAME = "laravel"
        DB_PASSWORD = "secret"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/MdAshrafulHasan/laravel_project_run.git'
            }
        }

        stage('Start Services') {
            steps {
                
                sh '''
                    echo 📦 Cleaning old DB container if exists...
                    docker rm -f laravel_db || true
                    echo 📦 Starting DB service...
                    docker-compose up -d laravel_db
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    docker-compose run --rm laravel_app bash -c "
                        composer install --no-interaction --prefer-dist --optimize-autoloader &&
                        cp .env.example .env || true &&
                        php artisan key:generate
                    "
                '''
            }
        }

        stage('Run Migrations') {
            steps {
                sh '''
                    docker-compose run --rm laravel_app bash -c "
                        php artisan config:clear &&
                        php artisan migrate --force
                    "
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    docker-compose run --rm laravel_app bash -c "
                        if [ -f ./vendor/bin/phpunit ]; then
                            ./vendor/bin/phpunit
                        else
                            echo '⚠️ No tests found, skipping...'
                        fi
                    "
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t laravel-app .'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker-compose up -d laravel_app || docker compose up -d laravel_app'
                echo "🚀 Laravel app deployed successfully!"
            }
        }
    }

    post {
        always {
            echo "✅ Pipeline finished!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
