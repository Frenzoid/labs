const express = require('express')
const { Sequelize, DataTypes } = require('sequelize');

const app = express();
const port = 3000;

const sequelize = new Sequelize(
  process.env.DB_NAME.toString(),
  process.env.DB_USER.toString(),
  process.env.DB_PASS.toString(), {
  host: process.env.DB_HOST.toString(),
  port: process.env.DB_PORT,
  dialect: 'postgres',
  logging: false,
});

const Lista = sequelize.define('Lista', {
  texto: DataTypes.STRING,
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  }
});

async function start() {
  try {
    await sequelize.authenticate();
    console.log('Conexión establecida!');

    await Lista.sync({ force: true });
    console.log("Insetando datos iniciales...");

    await Lista.create({ texto: 'Leche' });
    await Lista.create({ texto: 'Galletas' });
    await Lista.create({ texto: 'Harina' });

  } catch (error) {
    console.error('No se pudo conectar con la base de datos:', error);
  }
}

app.get('/add/:texto', async (req, res) => {
  const texto = req.params.texto;
  await Lista.create({ texto });
  res.send(`Elemento ${texto} añadido a la lista`);
});

app.get('/del/:texto', async (req, res) => {
  const texto = req.params.texto;
  await Lista.destroy({ where: { texto } });
  res.send(`Elemento ${texto} eliminado de la lista`);
});

app.get('/', async (req, res) => {
  const lista = await Lista.findAll();
  res.send(lista)
});

app.listen(port, async () => {
  await start();
  console.log(`Servidor escuchando en el puerto  ${port}`)
});