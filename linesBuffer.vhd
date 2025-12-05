library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linesBuffer is
	generic(COLUMN_LENGTH: integer := 8);-- Define o tamanho do buffer (largura da imagem/número de colunas)
 
	port(clock: in std_logic;		-- Sinal de clock para sincronização
			reset: in std_logic;		-- Sinal de reset
			wr_en: in std_logic;		-- Habilita a escrita de um novo pixel nos buffers
			data_in: in std_logic_vector(7 downto 0);		-- Pixel de entrada Linha N
			data_out1: out std_logic_vector(7 downto 0);	-- Saída 1: Pixel da Linha N-2 
			data_out2: out std_logic_vector(7 downto 0);	-- Saída 2: Pixel da Linha N-1 
			data_out3: out std_logic_vector(7 downto 0)	-- Saída 3: Pixel da Linha N 
	);
end linesBuffer;

architecture behavior of linesBuffer is
	
	component lineFifo -- Declaração do componente `lineFifo` que será instanciado três vezes
		generic(COLUMN_LENGTH: integer := 16); 
		port(	clock: in std_logic;
				reset: in std_logic;
				wr_en: in std_logic;
				data_in: in std_logic_vector(7 downto 0);
				data_out: out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal OUT1, OUT2, OUT3: STD_logic_vector(7 downto 0);	-- Sinais internos para conectar a saída de um FIFO com a entrada do próximo
	
begin
	L3:  lineFifo generic map(COLUMN_LENGTH) port map(clock, reset, wr_en, data_in, OUT3);
	L2:  lineFifo generic map(COLUMN_LENGTH) port map(clock, reset, wr_en, OUT3, OUT2);
	L1:  lineFifo generic map(COLUMN_LENGTH) port map(clock, reset, wr_en, OUT2, OUT1);
	
	data_out3 <= OUT3;
	data_out2 <= OUT2;
	data_out1 <= OUT1;
	
end behavior;
			
			