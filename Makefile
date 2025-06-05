#*Environment Variables*
ENV ?= dev
VERSION_TYPE ?= build
CHANNEL ?= alpha
PLATFORM ?= mobile

#*Generated Variables*
ENVIRONMENT := $(if $(filter dev,$(ENV)),development,$(if $(filter stage,$(ENV)),staging,production))
APP_NAME ?= $(if $(filter dev,$(ENV)),[DEV] Cv App,$(if $(filter stage,$(ENV)),[STAGE] Cv App,Cv App))

#*Makefile Commands*
#? Run `make test` to run tests from the test folder
test:
	@echo "Running test..."	
	@flutter clean
	@flutter pub get
	@flutter test

#? Run `make gen` to run the build runner to generate the necessary files
gen:
	@echo "Building Runner..."
	@flutter pub run build_runner build --delete-conflicting-outputs
	@$(MAKE) clean

#? Run `make clean` to clean up the project
clean:
	@echo "Cleaning up..."
	@flutter clean && flutter pub get


#? Run `make build-android` to build the Android app
build-android:
	@echo "Building Android ${ENVIRONMENT} Release..."
	@flutter build appbundle -t lib/environments/${ENV}/main.dart --flavor ${ENVIRONMENT} --obfuscate


#? Run `make build-ios` to build the iOS app
build-ios:
	@echo "Building iOS ${ENVIRONMENT} Release..."
	@flutter build ipa -t lib/environments/${ENV}/main.dart --flavor ${ENVIRONMENT} --build-name ${ENVIRONMENT} --obfuscate

#? Run `make build-web` to build the Web app
build-web:
	@echo "Building Web ${ENVIRONMENT} Release..."
	@flutter build web -t lib/environments/${ENV}/main.dart


#? Run `make deploy-android` to deploy the Android app
deploy-android:	
	@cd android/fastlane && bundle exec fastlane deploy_${ENV} filePath:"../build/app/outputs/bundle/${ENVIRONMENT}Release/app-${ENVIRONMENT}-release.aab" channel:"${CHANNEL}"

#? Run `make deploy-ios` to deploy the iOS app
deploy-ios:	
	@cd ios/fastlane && bundle exec fastlane deploy_${ENV} filePath:"../build/ios/ipa/${APP_NAME}.ipa" channel:"${CHANNEL}"


#? Run `make deploy-web` to deploy the Web app
deploy-web:
	@echo "Deploying Web Build for ${ENVIRONMENT} Release..."; \
	$(MAKE) build-web; \
	firebase use ${ENVIRONMENT}; \
	firebase deploy --only hosting; \
	firebase use default;


#? Run `make build` to build the app
#? builds the iOS app, Android app, and Web app
build: build-android build-ios build-web


#? Run `make deploy` to deploy the app
#? deploys the iOS app, Android app, and Web app
#? also bumps the version based on the version type		
deploy: 
	@echo "Deploying ${ENV} environment..." ; \
	$(MAKE) test ; \
	if [ "$(PLATFORM)" = "mobile" ] || [ "$(PLATFORM)" = "both" ]; then \
		echo "Deploying mobile platform..." ; \
		$(MAKE) build-android; \
		$(MAKE) deploy-android ; \
		$(MAKE) build-ios; \
		$(MAKE) deploy-ios ; \
	fi ; \
	if [ "$(PLATFORM)" = "web" ] || [ "$(PLATFORM)" = "both" ]; then \
		echo "Deploying web platform..." ; \
		$(MAKE) build-web; \
		$(MAKE) deploy-web ; \
	fi


#? Run `make bump-build` to bump the build version
bump-build:
	@dart tools/bump.dart build

#? Run `make bump-patch` to bump the patch version
bump-patch:
	@dart tools/bump.dart patch

#? Run `make bump-minor` to bump the minor version
bump-minor:
	@dart tools/bump.dart minor

#? Run `make bump-major` to bump the major version
bump-major:	
	@dart tools/bump.dart major


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

.PHONY: test clean deploy-android deploy-ios deploy-web gen bump-build bump-patch bump-minor bump-major bump-version
