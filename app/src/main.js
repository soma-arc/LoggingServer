import express from 'express';

async function main() {
    const app = express();
    app.use(express.json());

    const port = 8080;

    app.get('/', (req, res) => {
        res.send({
            message: 'foobar'
        });
    });

    app.post('/log', (req, res) => {
        console.error(req.body);
        res.send({
            message: 'ok'
        });
    });

    app.listen(port, () => {
        console.log(`Listening on ${port}`);
    });
}

main();
