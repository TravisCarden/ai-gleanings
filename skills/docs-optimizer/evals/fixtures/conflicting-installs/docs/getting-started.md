# Getting Started

You can install the service with npm, yarn, or Docker.

## With npm

```bash
npm install
npm start
```

## With yarn

```bash
yarn install
yarn start
```

## With Docker

```bash
docker build -t acme-service .
docker run -p 3000:3000 acme-service
```

The Docker image is the recommended option for production deployments because it pins all system dependencies.

The service expects `WIDGET_API` to point at the widget API. Use `https://api.acme.com/v2/widgets`.
