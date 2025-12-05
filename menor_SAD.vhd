library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity menor_SAD is
  port (
    SAD_1 : in unsigned(15 downto 0);	-- Valor SAD do Candidato 1
    index_1 : in unsigned(7 downto 0);	-- Índice associado ao Candidato 1
    SAD_2 : in unsigned(15 downto 0);	-- Valor SAD do Candidato 2
    index_2 : in unsigned(7 downto 0);	-- Índice associado ao Candidato 2.
    SAD_out  : out unsigned(15 downto 0);   	-- O menor valor SAD encontrado entre os dois
	 index_out : out unsigned(7 downto 0)		-- O índice do bloco que gerou o menor SAD
  );
end menor_SAD;

architecture behavior of menor_SAD is

begin
	process(SAD_1, SAD_2, index_1, index_2)
	begin
		if (SAD_1 < SAD_2) then		-- Compara os valores SAD
			SAD_out <= SAD_1;			-- Se SAD_1 for menor, seleciona o par (SAD_1, index_1)
			index_out <= index_1;
		else
			SAD_out <= SAD_2;			-- Se SAD_2 for menor OU IGUAL a SAD_1, seleciona o par (SAD_2, index_2)
			index_out <= index_2;
		end if;
	end process;
end behavior;