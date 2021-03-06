class Neuronio
  
  AT=0.5
  
  attr_accessor :sigma, :sinapses, :v, :y, :e, :x_atual, :id
  
  def initialize sinapses = []
    @sinapses = sinapses
  end
  
  def calcular_v vetor_x
    @x_atual = vetor_x 
    @x_atual
    sum = 0
    @x_atual.each_with_index do |x, i|
      sum += @sinapses[i] * x
    end
    @v = sum
  end
  
  def calcular_y
    @y = 1 / (1+ exp(-Neuronio::AT * @v))
  end

  def calcular_sigma somatorio = @e 
    @sigma = Neuronio::AT * @y*(1-@y) * somatorio 
  end
  
  def calcular_erro yd
    @e = yd - @y
  end
  
  def atualizar_sinapses eta
    puts "Atualizar sinapses - neuronio #{@id}"
    novow,deltaWx =[],0
    @sinapses.each_with_index do |wx,i|
      deltaWx = eta * @sigma * @x_atual[i]
      wx += deltaWx
      novow << wx
    end
    puts "Delta = " + deltaWx.to_s 
    @sinapses = novow
    puts self
  end
 
  def to_s
    sinapses_s = @sinapses.empty? ? "" : "SINAPSES = #{@sinapses} " 
    erro_s = @e.nil? ? "" :"ERRO = #{@e} " 
    sigma_s = @sigma.nil? ? "" : "SIGMA = #{@sigma} "
    "ID #{@id} " + sinapses_s + erro_s + sigma_s
  end
  
end
