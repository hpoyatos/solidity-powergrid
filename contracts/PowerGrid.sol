pragma solidity 0.4.24;


contract PowerGrid {
    enum Tipo { carvao, oleo, hibrido, lixo, nuclear, eolica }

    Usina[] public usinas;
    mapping(address => Jogador) public jogadores;
    mapping(uint8 => Usina) public mercadoUsinas;
    mapping(uint8 => Leilao) leiloes;

    struct Leilao {
        Usina usina;
        uint lanceMaisAlto;
        Jogador dono;
        bool ativo;
    }

    uint8 public leilaoAtual;

    struct Jogador {
        string nome;
        address carteira;
        uint elektros;
        mapping(uint8 => Usina) usinas;
    }

    struct Usina {
        Tipo tipo;
        uint8 preco;
        uint8 qtdeInsumos;
        uint8 casasEnergizadas;
    }

    struct Passo {
        uint8 numero;
        uint8 carvoes;
        uint8 oleos;
        uint8 lixos;
        uint8 uranios;
    }

    Passo[] public passos;
    uint public passoAtual;

    constructor() public {
        Usina memory u = Usina({
            tipo: Tipo.oleo,
            preco: 3,
            qtdeInsumos: 2,
            casasEnergizadas: 1
        });
        usinas.push(u);
        mercadoUsinas[u.preco] = u;

        u = Usina({
            tipo: Tipo.carvao,
            preco: 4,
            qtdeInsumos: 2,
            casasEnergizadas: 1
        });
        usinas.push(u);
        mercadoUsinas[u.preco] = u;

        u = Usina({
            tipo: Tipo.hibrido,
            preco: 5,
            qtdeInsumos: 2,
            casasEnergizadas: 1
        });
        usinas.push(u);
        mercadoUsinas[u.preco] = u;

        u = Usina({
            tipo: Tipo.lixo,
            preco: 6,
            qtdeInsumos: 1,
            casasEnergizadas: 1
        });
        usinas.push(u);
        mercadoUsinas[u.preco] = u;

        u = Usina({
            tipo: Tipo.oleo,
            preco: 7,
            qtdeInsumos: 3,
            casasEnergizadas: 2
        });
        usinas.push(u);

        u = Usina({
            tipo: Tipo.carvao,
            preco: 8,
            qtdeInsumos: 3,
            casasEnergizadas: 2
        });
        usinas.push(u);

        u = Usina({
            tipo: Tipo.oleo,
            preco: 9,
            qtdeInsumos: 1,
            casasEnergizadas: 1
        });
        usinas.push(u);

        u = Usina({
            tipo: Tipo.carvao,
            preco: 10,
            qtdeInsumos: 2,
            casasEnergizadas: 2
        });
        usinas.push(u);

        u = Usina({
            tipo: Tipo.eolica,
            preco: 13,
            qtdeInsumos: 0,
            casasEnergizadas: 1
        });
        usinas.push(u);

        u = Usina({
            tipo: Tipo.nuclear,
            preco: 11,
            qtdeInsumos: 1,
            casasEnergizadas: 2
        });
        usinas.push(u);

        Passo memory p1 = Passo({numero: 1,
            carvoes: 3,
            oleos: 2,
            lixos: 1,
            uranios: 1
        });
        passos.push(p1);

        passoAtual = 0;



    }

    function entrarNoJogo(string pNome) public {
        jogadores[msg.sender] = Jogador({
           nome: pNome,
           carteira: msg.sender,
           elektros: 50
        });
    }

    function queroComprar(uint8 numeroUsina, uint lance) public {
        require(jogadores[msg.sender].elektros >= lance);
        //require(mercadoUsinas[numeroUsina] )

        leiloes[mercadoUsinas[numeroUsina].preco] = Leilao({
            usina: mercadoUsinas[numeroUsina],
            lanceMaisAlto: lance,
            dono: jogadores[msg.sender],
            ativo: true
        });
        leilaoAtual = mercadoUsinas[numeroUsina].preco;
    }

    function darLance(uint lance) public {
        require(jogadores[msg.sender].elektros >= lance);
        require(leiloes[leilaoAtual].lanceMaisAlto < lance);

        leiloes[leilaoAtual].dono = jogadores[msg.sender];
        leiloes[leilaoAtual].lanceMaisAlto = lance;

    }

    function finalizarLeilao() public {
        address carteira = leiloes[leilaoAtual].dono.carteira;

        leiloes[leilaoAtual].ativo = false;
        jogadores[carteira].elektros = jogadores[carteira].elektros - leiloes[leilaoAtual].lanceMaisAlto;
        jogadores[carteira].usinas[leiloes[leilaoAtual].usina.preco] = leiloes[leilaoAtual].usina;
        delete mercadoUsinas[leiloes[leilaoAtual].usina.preco];
        leilaoAtual = 0;
    }

    function getLeilaoAtual() public view returns (uint8, string, uint) {
        return (leiloes[leilaoAtual].usina.preco, leiloes[leilaoAtual].dono.nome, leiloes[leilaoAtual].lanceMaisAlto);
    }
}
