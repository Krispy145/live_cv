#*Environment Variables*
ENV ?= dev
VERSION_TYPE ?= build
CHANNEL ?= alpha
PLATFORM ?= web
GITHUB_USERNAME ?= Krispy145
GITHUB_TOKEN ?=

#*Generated Variables*
ENVIRONMENT := $(if $(filter dev,$(ENV)),development,$(if $(filter stage,$(ENV)),staging,production))
APP_NAME ?= $(if $(filter dev,$(ENV)),[DEV] CV App,$(if $(filter stage,$(ENV)),[STAGE] CV App,CV App))

#? Help command
help:
	@echo "Available commands:"
	@echo "  make build-android    - Build Android APK"
	@echo "  make build-ios        - Build iOS IPA"
	@echo "  make build-web        - Build Web app"
	@echo "  make deploy-android   - Deploy Android app"
	@echo "  make deploy-ios       - Deploy iOS app"
	@echo "  make deploy-web       - Deploy Web app"
	@echo ""
	@echo "Environment options:"
	@echo "  ENVIRONMENT=development (default)"
	@echo "  ENVIRONMENT=staging"
	@echo "  ENVIRONMENT=production"
	@echo ""
	@echo "Examples:"
	@echo "  make build-android ENVIRONMENT=staging"
	@echo "  make deploy-web ENVIRONMENT=production"

#? Run `make build-android` to build the Android app
build-android:
	@echo "Building Android ${ENVIRONMENT} Release..."
	@flutter build apk -t lib/environments/${ENV}/main.dart --flavor ${ENVIRONMENT} --build-name ${ENVIRONMENT} --obfuscate

#? Run `make build-ios` to build the iOS app
build-ios:
	@echo "Building iOS ${ENVIRONMENT} Release..."
	@flutter build ipa -t lib/environments/${ENV}/main.dart --flavor ${ENVIRONMENT} --build-name ${ENVIRONMENT} --obfuscate

#? Run `make build-web` to build the Web app
build-web:
	@echo "Building Web ${ENVIRONMENT} Release..."
	@flutter build web -t lib/environments/${ENV}/main.dart --dart-define=GITHUB_USERNAME=${GITHUB_USERNAME} --dart-define=GITHUB_TOKEN=${GITHUB_TOKEN}


#? Run `make deploy-android` to deploy the Android app
deploy-android:	
	@cd android/fastlane && bundle exec fastlane deploy_${ENV} filePath:"../build/app/outputs/bundle/${ENVIRONMENT}Release/app-${ENVIRONMENT}-release.aab" channel:"${CHANNEL}"

#? Run `make deploy-ios` to deploy the iOS app
deploy-ios:
	@cd ios/fastlane && bundle exec fastlane deploy_${ENV} filePath:"../build/ios/ipa/${ENVIRONMENT}/Cv App.ipa" channel:"${CHANNEL}"

#? Run `make deploy-web` to deploy the Web app
deploy-web: build-web
	@echo "Deploying Web ${ENVIRONMENT} to Firebase..."
	@if [ "$(ENV)" = "dev" ]; then \
		firebase deploy --only hosting --project cv-personal-app-dev; \
	elif [ "$(ENV)" = "stage" ]; then \
		firebase deploy --only hosting --project cv-personal-app-stage; \
	elif [ "$(ENV)" = "prod" ]; then \
		firebase deploy --only hosting --project cv-personal-app-prod; \
	else \
		echo "Unknown environment: $(ENV)"; \
		exit 1; \
	fi

#? Run `make clean` to clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@flutter clean
	@flutter pub get

#? Run `make test` to run tests
test:
	@echo "Running tests..."
	@flutter test

#? Run `make analyze` to analyze code
analyze:
	@echo "Analyzing code..."
	@flutter analyze

#? Run `make format` to format code
format:
	@echo "Formatting code..."
	@dart format .

#? Run `make pub-get` to get dependencies
pub-get:
	@echo "Getting dependencies..."
	@flutter pub get

#? Run `make pub-upgrade` to upgrade dependencies
pub-upgrade:
	@echo "Upgrading dependencies..."
	@flutter pub upgrade

#? Run `make doctor` to check Flutter installation
doctor:
	@echo "Checking Flutter installation..."
	@flutter doctor

#? Run `make devices` to list available devices
devices:
	@echo "Listing available devices..."
	@flutter devices

#? Run `make run-dev` to run in development mode
run-dev:
	@echo "Running in development mode..."
	@flutter run -t lib/environments/dev/main.dart --flavor development --dart-define=GITHUB_USERNAME=Krispy145 --dart-define=GITHUB_TOKEN=

#? Run `make run-stage` to run in staging mode
run-stage:
	@echo "Running in staging mode..."
	@flutter run -t lib/environments/stage/main.dart --flavor staging --dart-define=GITHUB_USERNAME=Krispy145 --dart-define=GITHUB_TOKEN=

#? Run `make run-prod` to run in production mode
run-prod:
	@echo "Running in production mode..."
	@flutter run -t lib/environments/prod/main.dart --flavor production --dart-define=GITHUB_USERNAME=Krispy145 --dart-define=GITHUB_TOKEN=

#? Run `make run-web` to run on web
run-web:
	@echo "Running on web..."
	@flutter run -d chrome -t lib/environments/dev/main.dart --dart-define=GITHUB_USERNAME=Krispy145 --dart-define=GITHUB_TOKEN=

#? Run `make bump-build` to bump the build version
bump-build:
	@echo "Bumping build version..."

#? Run `make bump-patch` to bump the patch version
bump-patch:
	@echo "Bumping patch version..."

#? Run `make bump-minor` to bump the minor version
bump-minor:
	@echo "Bumping minor version..."

#? Run `make bump-major` to bump the major version
bump-major:
	@echo "Bumping major version..."

#? Run `make bump-version` to bump the version based on the version type
bump-version:
	@echo "Bumping version for $(ENV) environment of $(VERSION_TYPE) type..."; \
		$(MAKE) bump-build; \
		if [ "$(VERSION_TYPE)" = "patch" ]; then \
			$(MAKE) bump-patch; \
		elif [ "$(VERSION_TYPE)" = "minor" ]; then \
			$(MAKE) bump-minor; \
		elif [ "$(VERSION_TYPE)" = "major" ]; then \
			$(MAKE) bump-major; \
		fi

#? Run `make deploy` to deploy the app
#? deploys based on platform selection
deploy: 
	@echo "Deploying ${ENV} environment..." ; \
	if [ "$(PLATFORM)" = "web" ] || [ "$(PLATFORM)" = "both" ]; then \
		echo "Deploying web platform..." ; \
		$(MAKE) build-web; \
		$(MAKE) deploy-web ; \
	fi

.PHONY: test clean deploy-android deploy-ios deploy-web gen bump-build bump-patch bump-minor bump-major bump-version deploy