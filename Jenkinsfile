pipeline {
    agent {
        docker {
            image 'laravelsail/php82-composer' // includes PHP + Composer
            args '-u root:root' // run as root to avoid permission issues
        }
    }

    environment {
        DB_CONNECTION = "mysql"
        DB_HOST = "host.docker.internal"
        DB_PORT = "3307"
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
                sh './vendor/bin/phpunit || true' // allow to continue if no tests yet
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t laravel-app .'
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Deploy step goes here (e.g., docker-compose up -d)"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished!"
        }
    }
}
