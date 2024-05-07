# Como "dockerizar" esta aplicação?

Temos uma aplicação de uma API simples, apenas um boilerplate do NESTJS.

O que ela precisa?
- node instalado
- instalar as dependências (npm install)
- buildar a aplicação (npm run build)
- iniciar a aplicação (npm start)

Podemos montar nosso Dockerfile, usando já uma imagem leve de node (node:18-slim), e rodar os comandos para copiar, instalar as dependências, e então rodar a aplicação na porta que foi exposta, e é utilizada pela API:

```dockerfile
FROM node:18-slim

WORKDIR /usr/src/app

COPY package.json ./

RUN yarn 

COPY . .

RUN yarn run build

EXPOSE 3000

CMD ["yarn", "run", "start"]
```

Feito isso, podemos dar o build da nossa imagem:

```bash
docker build -t api-empacotada .
```

> Estamos usando o ".", pois temos o arquivo "Dockerfile" na raiz do nosso projeto, é lido como um "index" da pasta root do nosso projeto. (senão teria que ser passado o parâmetro `-f` para fazer referência ao arquivo com as instruções para buildar a imagem da aplicação)

Agora podemos rodar nossa aplicação a partir da imagem:

```bash
docker run --rm -p 3001:3000 api-empacotada
```

> Usamos o `--rm` pois um container tem um ciclo de vida, então quando ele for parado ele é excluído.abs
> Também usamos a porta `3001` para ficar claro que estamos acessando a aplicação pelo docker, e não pelo ambiente local do host.

E pronto, tudo certo!
Temos nossa aplicação NestJS empacotada em uma imagem docker!
```bash
⟩ http GET :3001/
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 12
Content-Type: text/html; charset=utf-8
Date: Tue, 07 May 2024 14:57:06 GMT
ETag: W/"c-Lve95gjOVATpfV8EL5X4nxwjKHE"
Keep-Alive: timeout=5
X-Powered-By: Express

Hello World!
```
