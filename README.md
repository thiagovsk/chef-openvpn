# chef-openvpn
Livro de receitas Chef para instalar uma rede de testes openvpn.

Para chegar Chef funcionando corretamente em sua máquina local que você precisa de algumas coisas.

- Certifique-se que você possui o ruby instalado em sua máquina, em uma versão
a partir da 1.9.3

- Instale as dependências

```
gem install knife-solo --no-ri --no-rdoc
gem install librarian-chef --no-ri --no-rdoc
```

- Clone o repositório do projeto

```
git clone https://github.com/thiagovsk/chef-openvpn
```

- Certifique-se que sua chave pública está no servidor destino, ou que você
possua a senha de root em mãos.

- De um modo geral, para executar a receita basta apenas

```
knife solo bootstrap root@YOUR_SERVER_IP_OR_ALIAS nodes/YOUR_SERVER_IP_OR_ALIAS.json
```

- No nosso caso, basta:

```
knife solo bootstrap root@107.170.14.241  nodes/production.json
```

- Para pegar os arquivos necessários você precisa apenas executar um script
para pegar os arquivos necessários

```
./get_keys.sh ip_da_maquina nome_chave_ex_cliente_1 caminho_destino
```

- Por exemplo:

```
./get_keys.sh  107.170.14.241 client1 ~/chef-openvpn/
```

- Por fim basta configurar o seu cliente para acessar a rede, como por exemplo:

[Sites Using React](https://github.com/thiagovsk/chef-openvpn/wiki/Usando-a-Rede-VPN-no-seu-computador)
