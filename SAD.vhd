library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SAD is
  port (
	 -- Linhas 1, 2 e 3 da primeira janela, cada linha contém 3 pixels de 8 bits 
    E_line1 : in std_logic_vector(23 downto 0);
    E_line2 : in std_logic_vector(23 downto 0);
    E_line3 : in std_logic_vector(23 downto 0);
	 -- Linhas 1, 2 e 3 da segunda janela, cada linha contém 3 pixels de 8 bits 
    D_line1 : in std_logic_vector(23 downto 0);
    D_line2 : in std_logic_vector(23 downto 0);
    D_line3 : in std_logic_vector(23 downto 0);
	 -- Saída do resultado final do SAD
    SADout  : out unsigned(15 downto 0) 
  );
end SAD;

architecture behavior of SAD is
  -- Função auxiliar para diferença absoluta
  function abs_diff(a, b : unsigned(7 downto 0)) return unsigned is
  begin
	 -- Retorna o resultado da subtração do maior pelo menor, garantindo que o resultado seja sempre positivo
    if a >= b then
      return a - b;
    else
      return b - a;
    end if;
  end function;
  
begin

  process(E_line1, E_line2, E_line3, D_line1, D_line2, D_line3)
    variable sum : unsigned(15 downto 0) := (others => '0');	-- Variável para acumular a soma das diferenças absolutas
    variable pixelE, pixelD : unsigned(7 downto 0);				-- Variáveis temporárias para armazenar os pixels individuais (8 bits) durante a iteração
  begin
    sum := (others => '0');	-- Zera o acumulador de soma a cada nova execução do processo

	 -- Cálculo do SAD para Linha 1
    for i in 0 to 2 loop		-- Loop para iterar sobre os 3 pixels da linha
      pixelE := unsigned(E_line1((i+1)*8-1 downto i*8));
      pixelD := unsigned(D_line1((i+1)*8-1 downto i*8));
      sum := sum + resize(abs_diff(pixelE, pixelD), 16);	-- Calcula a diferença absoluta e a adiciona à soma
    end loop;

    -- Cálculo do SAD para Linha 2
    for i in 0 to 2 loop
      pixelE := unsigned(E_line2((i+1)*8-1 downto i*8));
      pixelD := unsigned(D_line2((i+1)*8-1 downto i*8));
      sum := sum + resize(abs_diff(pixelE, pixelD), 16);
    end loop;

    -- Cálculo do SAD para Linha 3
    for i in 0 to 2 loop
      pixelE := unsigned(E_line3((i+1)*8-1 downto i*8));
      pixelD := unsigned(D_line3((i+1)*8-1 downto i*8));
      sum := sum + resize(abs_diff(pixelE, pixelD), 16);
    end loop;

    SADout <= sum;	-- O resultado acumulado é enviado para a porta de saída
  end process;

end behavior;
