

## Packaging For Production

1. Create `.env` at src, i.e.

```sh
cp src/.env.example src/.env
```

2. Run this command
```sh
 export PATH=$PATH:$(go env GOPATH)/bin
```


2. Update your `.env` variables for production

- Point to your prod database
- Update JWT issuer, secret key , blah blah
- Basically just follow good production practice

3. Download Swag for generating docs

```sh
go get -u github.com/swaggo/swag/cmd/swag
go install github.com/swaggo/swag/cmd/swag@latest
```

- Generate Swagger Docs. You have to generate swagger docs before packaging the app.

```sh
export PATH=$(go env GOPATH)/bin:$PATH
swag init -g src/api/app.go --output ./src/api/docs # Generates Swagger
```

4. Build Your Image

- Permission the build script to run.

```
chmod +x docker-build.sh
```

- You could set the image port on `Dockerfile.prod`
- Run the build script. You must provide a version tag as shown below.

```
./docker-build.sh -v gofiber:1.0.0
```

---

### Todo

- [ ] Data Migrations ?
- [ ] Logger
- [ ] Unit tests

maybe?

- [ ] SMS notification (2FA ,Reset password code)
- [ ] GraphQL
- [ ] Deploy on Kubernetes
- [ ] Write an article

---

### Gotcha's

- Building Swago from source code - `go build -o swag.exe cmd/swag/main.go`

### Contribution

Open to Suggestions and Pull Requests

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
