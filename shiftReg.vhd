library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftReg is
	generic(DATA_WIDTH: integer := 8; 	-- Número de bits do pixel
				N: integer := 3				-- Número de elementos (pixels) que o registrador deve armazenar (tamanho da janela de processamento)
	); 			
	
	port(	clock: in std_logic;				-- Sinal de clock para sincronizar as operações
			reset: in std_logic;				-- Sinal de reset 
			en: in std_logic;					-- Sinal de habilitação 
			data_in: in std_logic_vector((DATA_WIDTH-1) downto 0);		-- Dados de entrada: pixel de largura DATA_WIDTH
			data_out: out std_logic_vector((N*DATA_WIDTH-1) downto 0)	-- Dados de saída: o conteúdo completo do buffer, com largura N * DATA_WIDTH
	);
end shiftReg;

architecture behavior of shiftReg is
	
	signal buffer_in: std_logic_vector(N*DATA_WIDTH-1 downto 0) := (others=>'0'); -- Sinal interno que armazena os dados
	
begin
	data_out <= buffer_in; -- A saída é sempre o conteúdo atual do buffer
	
	process(clock, reset)
	begin
		if(reset = '1') then
			buffer_in <= (others => '0'); 				-- Zera todo o conteúdo do buffer (estado inicial)
		elsif(rising_edge(clock) and en = '1') then 	-- O deslocamento ocorre na borda de subida do clock e se 'en' estiver ativo
				-- 'data_in' (DATA_WIDTH bits) entra no MSB (lado esquerdo).
            -- '&' (concatenação) une 'data_in' com o resto do buffer.
            -- 'buffer_in(N*DATA_WIDTH-1 downto DATA_WIDTH)' pega o conteúdo antigo do buffer, excluindo os DATA_WIDTH bits menos significativos (LSBs), que são deslocados para fora e perdidos.
			buffer_in <= data_in & buffer_in(N*DATA_WIDTH-1 downto DATA_WIDTH);
		end if;
	end process;
	
end behavior;