DOCS_PATH := docs
DB_URL=postgres://doctor_vet:doctor_vet@localhost:5432/doctor_vet?sslmode=disable
MIGRATIONS_DIR=./migrations

run-app:
	go run ./cmd main.go


# Запуск инфраструктуры
infra-start:
	docker-compose up -d
	@echo "Ожидание запуска базы данных..."
	@sleep 3
	@make migrate-up

infra-stop:
	docker-compose down

migrate-up:
	goose -dir $(MIGRATIONS_DIR) postgres "$(DB_URL)" up

migrate-down:
	goose -dir $(MIGRATIONS_DIR) postgres "$(DB_URL)" down

migrate-status:
	goose -dir $(MIGRATIONS_DIR) postgres "$(DB_URL)" status

#goose -dir ./migrations create init sql - init (название)

doc-swagger:
	@swag init \
		--parseDependency \
		--parseInternal \
		--dir transport \
		--generalInfo public.go \
		--parseDepth 1 \
		--output ${DOCS_PATH}
	@rm ${DOCS_PATH}/docs.go