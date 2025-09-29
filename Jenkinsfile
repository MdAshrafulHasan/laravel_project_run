pipeline {
    agent any

    environment {
        APP_CONTAINER = 'laravel_app'
        DB_CONTAINER = 'laravel_db'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Checking out source code...'
                checkout scm
            }
        }

        stage('Start Services') {
            steps {
                echo '📦 Cleaning old containers if they exist...'
                sh "docker rm -f ${DB_CONTAINER} ${APP_CONTAINER} || true"

                echo '📦 Starting DB and App services...'
                sh "docker-compose up -d ${DB_CONTAINER} ${APP_CONTAINER}"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '📦 Installing PHP dependencies...'
                sh """
                    docker exec ${APP_CONTAINER} bash -c '
                        composer install --no-interaction --prefer-dist --optimize-autoloader &&
                        cp .env.example .env || true &&
                        php artisan key:generate
                    '
                """
            }
        }

        stage('Run Migrations') {
            steps {
                echo '🗄 Running database migrations...'
                sh "docker exec ${APP_CONTAINER} php artisan migrate --force"
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running tests...'
                sh "docker exec ${APP_CONTAINER} php artisan test"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh "docker-compose build ${APP_CONTAINER}"
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 Deploy stage placeholder'
                // Add deployment commands here
            }
        }
    }

    post {
        always {
            echo '🔔 Pipeline finished!'
        }
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
