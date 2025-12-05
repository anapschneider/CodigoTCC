library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity imageRead is
  generic (
    LINE_LENGTH    : integer := 10; 	-- Largura da imagem (colunas)
    IMAGE_HEIGHT   : integer := 10;  	-- Altura da imagem (linhas)
    IMAGE_FILE_NAME: string  := "G:\Meu Drive\Faculdade\TCC\Imagem4\viewE.txt"
  );
  port (
    clock     	: in  std_logic;		-- Sinal de clock para sincronização
    reset      : in  std_logic;		-- Sinal de reset
	 re        	: in  std_logic;  	-- Habilita a leitura do próximo pixel no clock
    we        	: out  std_logic;  	-- inaliza que um pixel válido (pixel_out) está disponível
    pixel_out 	: out std_logic_vector(7 downto 0)	-- Pixel de saída (8 bits)
);
end imageRead;

architecture behavior of imageRead is

  -- Tipo de memória: um array linear (1D) de pixels, totalizando LINE_LENGTH * IMAGE_HEIGHT
  type image_mem_type is array(0 to ((LINE_LENGTH*IMAGE_HEIGHT)-1) -- Sinal que representa a memória de imagem, inicializada com o conteúdo do arquivo) of std_logic_vector(7 downto 0);
  
  -- Função para carregar o conteúdo de um arquivo em uma memória interna (RAM virtual para simulação) ANTES do início da simulação
  impure function init_mem(mif_file_name : in string) return image_mem_type is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv  : bit_vector(7 downto 0);
    variable temp_mem : image_mem_type;
  begin
    for i in temp_mem'range loop
      exit when endfile(mif_file);		-- Para quando o arquivo termina
      readline(mif_file, mif_line);		-- Lê uma linha do arquivo
      read(mif_line, temp_bv);			-- Converte a linha lida para um bit_vector (8 bits)
      temp_mem(i) := to_stdlogicvector(temp_bv);	-- Converte para std_logic_vector e armazena na memória
    end loop;
    return temp_mem;
  end function;
  
  -- Sinal que representa a memória de imagem, inicializada com o conteúdo do arquivo
  signal image_mem : image_mem_type := init_mem(IMAGE_FILE_NAME);
  signal pix_count : integer := 0;  -- Contador que indica qual pixel da memória está sendo lido

begin

  process(clock, reset)
  begin
    if (reset = '1') then
      pix_count  <= 0;	-- Reinicia a leitura para o primeiro pixel
		we <= '0';			-- Desabilita a saída
    elsif rising_edge(clock) then
      if (re = '1') then	-- A leitura só avança se o read estiver ativo
		  -- image_mem'high then retorna o valor máximo do image_mem (LINE_LENGTH*IMAGE_HEIGHT)
        if pix_count <= image_mem'high then 	-- Verifica se o contador está dentro do limite da memória
				if(pix_count = image_mem'high) then
					pixel_out <= "00000000";				-- Se for o último endereço manda '0' 
				else
					pixel_out <= image_mem(pix_count);	-- Carrega o pixel do endereço atual
				end if;
				we <= '1';							-- Habilita a escrita, indicando que um dado (pixel_out) é válido
				pix_count <= pix_count + 1; 	-- Move o ponteiro para o próximo pixel
		  else
				we <= '0';	-- Terminou de ler todos os pixels, desabilita a saída
        end if;
      end if;
    end if;
  end process;

end behavior;