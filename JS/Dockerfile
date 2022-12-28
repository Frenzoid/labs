# Basandote en la imagen oficial de nodejs
FROM node:latest

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Copia el archivo package.json
COPY package.json ./

# Copia el resto de los archivos
COPY apirest.js .

# Instala las dependencias
RUN npm install

# Arranca el servidor
CMD [ "node", "apirest.js" ]