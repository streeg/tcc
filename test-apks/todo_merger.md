TCC- mergear resultado cognicrypt com ferramentas análise biblioteca
1- abrir arquivo do libscout/radar e pegar o nome do arquivo analisado. ok
2- abrir arquivo do result do crypto com mesmo nome do arquivo analisado. ok
3- criar arquivo novo (merge) ok
4- procurar no primeiro arquivo (cogni) dentro da hash results se o parâmetro uri contém parte do valor de package do segundo arquivo (libscout/libradar) ok
5- se positivo, adicionar no arquivo novo dentro de results parâmetro "externLibrary" com valor da biblioteca até o '::' ok + -
6- se falso, pular. ok
7- fechar arquivos. ok
8- replicar o processo com o libradar