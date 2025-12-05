library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lineFifo is
	generic(COLUMN_LENGTH: integer := 16); -- Define o tamanho do buffer (largura da imagem/número de colunas)
	
	port(clock: in std_logic;		-- Sinal de clock para sincronização
			reset: in std_logic;		-- Sinal de reset
			wr_en: in std_logic;		-- Habilita a escrita de um novo dado no buffer
			data_in: in std_logic_vector(7 downto 0);		-- Dado de entrada (pixel) de 8 bits
			data_out: out std_logic_vector(7 downto 0)	-- Dado de saída (pixel) do buffer
	);
end lineFifo;

architecture behavior of lineFifo is

	type ram_type is array (0 to COLUMN_LENGTH-1) of std_logic_vector(7 downto 0); 	-- Declaração do tipo de memória (RAM) que formará o buffer de linha
																												-- É um array de tamanho COLUMN_LENGTH, onde cada elemento armazena 8 bits (um pixel)
	
	signal line_buffer: ram_type;	-- Sinal que representa a memória (o buffer de pixels da linha)
	signal wrPtr: integer := 0;	-- Ponteiro de Escrita: Indica o endereço onde o próximo dado será escrito
	signal rdPtr: integer := 1;	-- Ponteiro de Leitura: Indica o endereço de onde o dado será lido (o dado mais antigo)
	
begin

	process(clock, reset)
	begin
		if(reset = '1') then
			wrPtr <= 0;		-- Reinicia o ponteiro de escrita
			rdPtr <= 1;		-- Reinicia o ponteiro de leitura
		
		elsif(rising_edge(clock) and wr_en = '1') then 	-- Executada na borda de subida do clock E se a escrita estiver habilitada
			line_buffer(wrPtr) <= data_in;					-- Escreve o novo pixel ('data_in') no endereço atual do ponteiro de escrita
			if(wrPtr = COLUMN_LENGTH-1) then					-- Se atingir o final, volta para 0, senão incrementa
				wrPtr <= 0;
			else
				wrPtr <= wrPtr + 1;
			end if;
			
			if(rdPtr = COLUMN_LENGTH-1) then
				rdPtr <= 0;
			else
				rdPtr <= wrPtr + 1;								-- rdPtr segue wrPtr com um atraso de 1 posição
			end if;
		end if;
	end process;
	
	data_out <= line_buffer(rdPtr);	-- O dado de saída é sempre o conteúdo da memória no endereço rdPtr
	
end behavior;
			
			