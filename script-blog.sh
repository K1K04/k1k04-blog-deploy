#!/bin/bash

# Configuración
REPO_DEPLOY_URL="git@github.com:K1K04/k1k04-blog-deploy.git" # Repositorio de despliegue
DEPLOY_DIR="../k1k04-blog-deploy" # Directorio temporal para los archivos generados
BUILD_DIR="_site" # Directorio donde Jekyll genera el sitio

# Paso 1: Generar el sitio con Jekyll
echo "Generando el sitio con Jekyll..."
bundle exec jekyll build

# Paso 2: Clonar el repositorio de despliegue
echo "Clonando el repositorio de despliegue..."
if [ -d "$DEPLOY_DIR" ]; then
  rm -rf "$DEPLOY_DIR"
fi
git clone "$REPO_DEPLOY_URL" "$DEPLOY_DIR"

# Verificar si la clonación fue exitosa
if [ $? -ne 0 ]; then
  echo "Error al clonar el repositorio de despliegue."
  exit 1
fi

# Paso 3: Copiar los archivos generados al repositorio de despliegue
echo "Copiando archivos generados al repositorio de despliegue..."
cp -R "$BUILD_DIR/"* "$DEPLOY_DIR"

# Paso 4: Hacer commit y push de los cambios
cd "$DEPLOY_DIR" || { echo "No se pudo cambiar al directorio de despliegue"; exit 1; }

git add .
git commit -m "Actualización automática del sitio"
git push origin main

# Limpieza
cd ..
rm -rf "$DEPLOY_DIR"

echo "Despliegue completado exitosamente."
