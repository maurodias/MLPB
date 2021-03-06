#encoding: UTF-8
require File.expand_path("../neuronio", __FILE__)
include Math
class MLPB
  attr_accessor :neuronios, :vetores_treinamento, :num_epocas, :erro_desejado, :bias
  
  def initialize opts={}
    opts[:eta] ||= 0.5
    opts[:num_epocas] ||= 1
    opts[:erro_desejado] ||= -1

#    @bias = opts[:bias]
    @vetores_treinamento = []
    @eta = opts[:eta]
    @erro_desejado = opts[:erro_desejado]
    @num_epocas = opts[:num_epocas]
    @neuronios = {:inicial => [], :oculta => [], :saida => []}
  end

#  Criando método adicionar_neuronios para as tres seguintes camadas
  %w(inicial oculta saida).each do |camada|
    define_method ("adicionar_neuronio_"+camada).to_sym do |*neuronios| 
      neuronios.each { |neuronio| @neuronios[camada.to_sym] << neuronio }
    end 
  end

#  Criando método para alterar numero de neuronios para as tres seguintes camadas
  %w(inicial oculta saida).each do |camada|
    define_method ("alterar_num_neuronios_"+camada).to_sym do |n| 
      n.times { @neuronios[camada.to_sym] << Neuronio.new }
    end 
  end

  def adicionar_vetor_treinamento vetor
    @vetores_treinamento << vetor
  end
  
  def limpar_vetores_treinamento
    @vetores_treinamento = []
  end
  
  def treinar_rede
    inicializar_rede
    if @erro_desejado == -1
      @num_epocas.times { treinar_epoca }
    else
      begin
        treinar_epoca
        puts "erro quadratico atual = " + @erro_quadratico_atual.to_s
      end while @erro_desejado < @erro_quadratico_atual
    end
  end

  def to_s
    @neuronios.each { |n| p n}
    puts "-"*70  
  end
  
  private
  def inicializar_rede
    @vetores_treinamento.each { |vt| validar_vetor_treinamento vt}
#   adicionar bias vetor treinamento
    @vetores_treinamento.each { |vt| vt.first << 1} if true
    gerar_sinapses_iniciais
  end

  def treinar_epoca
    @vetores_treinamento.each { |vetor| treinar_por_vetor vetor; puts "+"*70 ;STDIN.gets}
    calcular_erro_quadratico
  end

  def treinar_por_vetor vetor
    vetor_gerado =[]   
    #calculo da primeira camada oculta
    @neuronios[:oculta].each_with_index do |neuronio, index|
      puts ""
      puts neuronio.inspect
      v = neuronio.calcular_v vetor.first
      puts "V: "+v.to_s
      y = neuronio.calcular_y 
      puts "Y: "+y.to_s
      vetor_gerado << neuronio.y
    end
    #adicionando baia
    vetor_gerado << 1 if true

    #calculo da camada de saida
    @neuronios[:saida].each_with_index do |neuronio, index|
      puts ""
      puts neuronio.inspect
      v = neuronio.calcular_v vetor_gerado
      puts "V: "+v.to_s
      y= neuronio.calcular_y 
      puts "Y: "+y.to_s
      
      #calcular_erro_ultima_camada
      e = neuronio.calcular_erro vetor.last[index]
      puts "E:"+e.to_s   
    end
    puts ""
    backpropragation vetor
  end

  def backpropragation vetor
    puts ""
    puts "BACKPROPRAGATION"
    
    @neuronios[:saida].each_with_index do |neuronio, index|
      puts ""
      puts neuronio.inspect
      #sigma da camada de saida
      s = neuronio.calcular_sigma
      puts "Sigma: "+s.to_s
      
      #atualizar_sinapses
      neuronio.atualizar_sinapses @eta
    end
    @neuronios[:oculta].each_with_index do |neuronio, index|
      puts ""
      puts neuronio.inspect
      #sigma da camada oculta
      somatorio = 0
      @neuronios[:saida].each_with_index { |n, i| somatorio += n.sigma * n.sinapses[index] }
#      @neuronios[:saida].each_with_index { |n, i| somatorio += n.sigma * n.sinapses[i] }
#     puts 'sigma = '+n.sigma.to_s + '  w = '+n.sinapses[index].to_s
      puts "Somatorio: " + somatorio.to_s
      s = neuronio.calcular_sigma somatorio
      puts "Sigma: "+s.to_s
      #atualizar_sinapses
      neuronio.atualizar_sinapses @eta
    end
    
    puts '','Vetor em treinamento' , vetor.to_s,''
    p self
  end

  def calcular_erro_quadratico
    sum = 0
    @neuronios[:saida].each {|n| sum += n.e } 
    @erro_quadratico_atual = sum/@neuronios[:saida].size
  end
  
# gera sinapses e ids dos neuronios
  def gerar_sinapses_iniciais
    @neuronios[:inicial].each  { |neuronio| neuronio.id = @neuronios[:inicial].index(neuronio)+ 1 }
    @neuronios[:oculta].each do |neuronio|
      if true
        neuronio.sinapses = ([1]*@neuronios[:inicial].size << 1) if neuronio.sinapses.size < @neuronios[:inicial].size + 1
        neuronio.id = @neuronios[:oculta].index(neuronio)+ 1 + @neuronios[:inicial].size 
      else
        neuronio.sinapses = ([1]*@neuronios[:inicial].size) if neuronio.sinapses.size < @neuronios[:inicial].size
        neuronio.id = @neuronios[:oculta].index(neuronio)+ 1 + @neuronios[:inicial].size 
      end
    end
    @neuronios[:saida].each do |neuronio|
      if true
        neuronio.sinapses = ([1]*@neuronios[:oculta].size << 1) if neuronio.sinapses.size < (@neuronios[:oculta].size + 1)
        neuronio.id = @neuronios[:saida].index(neuronio)+ 1 + @neuronios[:inicial].size+@neuronios[:oculta].size
      else
        neuronio.sinapses = ([1]*@neuronios[:oculta].size) if neuronio.sinapses.size < (@neuronios[:oculta].size)
        neuronio.id = @neuronios[:saida].index(neuronio)+ 1 + @neuronios[:inicial].size+@neuronios[:oculta].size
      end
    end
  end
   
  def validar_vetor_treinamento vt
    raise "Incompatibilidade do número de neuronios da camada inicial com o vetor de treinamento" unless (vt[0].size == @neuronios[:inicial].size and vt[1].size == @neuronios[:saida].size)
  end

end
