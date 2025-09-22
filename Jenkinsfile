pipeline {
    agent any

    environment {
        // Customize as per your setup
        PHP_VERSION = "8.2"
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

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                sh 'cp .env.example .env || true'
                sh 'php artisan key:generate'
            }
        }

        stage('Run Migrations') {
            steps {
                sh 'php artisan migrate --force'
            }
        }

        stage('Run Tests') {
            steps {
                sh './vendor/bin/phpunit'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t laravel-app .'
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Deploy step goes here (e.g., docker-compose up -d, or push to server)"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished!"
        }
    }
}
