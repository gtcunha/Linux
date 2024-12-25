#!/bin/bash

# Configurações
DB_USER="teampass_user"                 # Usuário do banco
DB_PASSWORD="teampass_password"             # Senha do banco
DB_HOST="localhost"                  # Endereço do servidor (localhost, IP, etc.)
DB_NAME="teampass_db"              # Nome do banco de dados
BACKUP_DIR="/backup"    # Diretório para salvar os backups
DATE=$(date +"%Y-%m-%d_%H-%M-%S")    # Timestamp para diferenciar os backups

# Criar diretório de backup, se não existir
mkdir -p "$BACKUP_DIR"

# Backup completo (schema + dados)
FULL_BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_full_backup_$DATE.sql"
echo "Realizando backup completo em: $FULL_BACKUP_FILE"
mysqldump -u $DB_USER -p$DB_PASSWORD -h $DB_HOST $DB_NAME > $FULL_BACKUP_FILE
if [ $? -eq 0 ]; then
    echo "Backup completo realizado com sucesso."
else
    echo "Erro ao realizar o backup completo."
    exit 1
fi

# Backup apenas do schema
SCHEMA_BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_schema_backup_$DATE.sql"
echo "Realizando backup do schema em: $SCHEMA_BACKUP_FILE"
mysqldump -u $DB_USER -p$DB_PASSWORD -h $DB_HOST --no-data $DB_NAME > $SCHEMA_BACKUP_FILE
if [ $? -eq 0 ]; then
    echo "Backup do schema realizado com sucesso."
else
    echo "Erro ao realizar o backup do schema."
    exit 1
fi

# Mensagem final
echo "Todos os backups foram concluídos e salvos em $BACKUP_DIR."

# Remoção de backups antigos (opcional - mantém apenas os últimos 7 dias)
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm -f {} \;
echo "Backups antigos removidos (mais de 7 dias)."

exit 0
