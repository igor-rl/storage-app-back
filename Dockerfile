# Etapa de construção
FROM node:18.12.1 AS builder
RUN apt-get update && apt-get install -y bash git && rm -rf /var/lib/apt/lists/*
WORKDIR /home/node/app
COPY ./package.json ./package-lock.json ./tsconfig.json ./
RUN npm ci
COPY . .
RUN npm run build

# Etapa de produção
FROM node:18.12.1-alpine3.15
WORKDIR /home/node/app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /home/node/app/dist ./dist
USER node
CMD ["node", "dist/main"]