library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity imageWrite is
    generic (
		  -- Número de linhas do arquivo de saída = número de pixels da imagem
        N_LINES : integer := 100000;  
		  -- Caminho e nome do arquivo de texto de saída
		  TEXT_FILE_NAME: string  := "G:/Meu Drive/Faculdade/TCC/Codigos/20251008-ImagemRochas/08102025-SaidaImagemRochas.txt" 
    );
    port (
        clk : in std_logic;				-- Sinal de clock para sincronização da escrita
		  enable: in std_logic;				-- Habilita/desabilita a escrita de dados
        var : in unsigned(7 downto 0) 	-- Dados de pixel (8 bits) a serem escritos a cada clock
    );
end entity;

architecture behavior of imageWrite is
    file f_out : text open write_mode is TEXT_FILE_NAME; -- Variável interna que representa o arquivo de texto aberto para escrita
    signal count : integer := 0; 								-- Contador de linhas (pixels) já escritos no arquivo.
begin

    process(clk)
        variable linha : line;								-- Buffer temporário para formatar a linha antes de gravar no arquivo
    begin
        if rising_edge(clk) and (enable = '1') then	-- Só é executada na borda de subida do clock e se o sinal 'enable' estiver ativo ('1')
            if count < N_LINES then							-- Verifica se o número de linhas escritas (count) é menor que o limite (N_LINES) 
                write(linha, std_logic_vector(var));  -- Escreve a variável no buffer linha em binário
                writeline(f_out, linha);              -- Grava a linha no arquivo
                count <= count + 1;							-- Atualiza o contador de linhas escritas
            else
                report "Escrita concluída: " & integer'image(N_LINES) & " linhas.";  -- Sinaliza que a escrita é concluída
            end if;
        end if;
    end process;

end architecture;
