pipeline {
    agent {
        docker {
            image 'laravel-build:latest'
            args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DB_CONNECTION = "mysql"
        DB_HOST = "laravel_db"       // must match service name in docker-compose.yml
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

        // stage('Start Services') {
        //     steps {
        //         sh '''
        //             echo "📦 Starting DB service..."
        //             docker compose up -d laravel_db || docker-compose up -d laravel_db
        //             echo "⏳ Waiting for DB to be ready..."
        //             sleep 20
        //         '''
        //     }
        // }

        stage('Install Dependencies') {
            steps {
                sh '''
                    composer install --no-interaction --prefer-dist --optimize-autoloader
                    cp .env.example .env || true
                    php artisan key:generate
                '''
            }
        }

        stage('Run Migrations') {
            steps {
                sh '''
                    php artisan config:clear
                    php artisan migrate --force
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    if [ -f ./vendor/bin/phpunit ]; then
                        ./vendor/bin/phpunit
                    else
                        echo "⚠️ No tests found, skipping..."
                    fi
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
                sh '''
                    docker compose up -d || docker-compose up -d
                    echo "🚀 Laravel app deployed successfully!"
                '''
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
