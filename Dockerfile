# Etapa de construcción de la aplicación Angular
FROM debian:latest AS build-stage


RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @angular/cli

# Crea una aplicación Angular en el directorio angular-app
WORKDIR /app
COPY practicasd/ /app/
RUN npm install && ng build --output-path=dist

# Etapa de configuración del servidor Apache
FROM debian:latest AS production-stage

# Instala Apache
RUN apt-get update && apt-get install -y apache2

# Copia los archivos de la aplicación Angular desde la etapa de construcción
#COPY --from=build-stage /app/dist /var/www/html
COPY --from=build-stage /app/dist/practicasd/browser /var/www/html/


# COPY --from=build-stage /practicasd/dist/practicasd/browser /app/public


COPY apache-config/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
