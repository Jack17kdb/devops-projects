import express from 'express';

const PORT = 5000;
const app = express();

app.use(express.json());

app.get('/', (req, res) => {
	res.status(200).json({ "message": "Welcome to my node app" });
});

app.listen(PORT, () => {
	console.log("Server listening on port: ", PORT);
});
