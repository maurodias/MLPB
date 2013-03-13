require File.expand_path("../MLPB", __FILE__)

rn = MLPB.new(:num_epocas=>1)
#rn = MLPB.new :erro_desejado=>0.001

rn.adicionar_vetor_treinamento [[1,0,1],[1,0,0]]
#rn.adicionar_vetor_treinamento [[1,0],[1,0]]
#rn.adicionar_vetor_treinamento [[0,0],[0,1]]
#rn.adicionar_vetor_treinamento [[1,1],[0,0]]
#rn.adicionar_vetor_treinamento [[0.5,1,0],[0]]

#rn.adicionar_vetor_treinamento [[1,0,1,1,0,1],[1,0,1]]

rn.alterar_num_neuronios_inicial 3
rn.alterar_num_neuronios_oculta 2
rn.alterar_num_neuronios_saida 3

#rn.alterar_num_neuronios_oculta 2
#rn.adicionar_neuronio_oculta Neuronio.new([0,1]) , Neuronio.new([1,0])
#rn.adicionar_neuronio_saida Neuronio.new([1,1]) , Neuronio.new([0,0])
#rn.alterar_num_neuronios_saida 2
rn.treinar_rede

