library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity janelaCompleta is
  generic (COLUMN_LENGTH : integer := 10;			-- Comprimento da coluna (largura da imagem) em pixels
			  TAM_JANELA_ESQUERDA: integer := 3 	-- Número de colunas da janela 
	);  

  port (	clock            : in  std_logic;		-- Sinal de clock para sincronizar as operações	
  			reset            : in  std_logic; 		-- Sinal de reset 
			fifo_en				: in  std_logic;		-- Sinal de habilitação da entrada de dados (pixel) no buffer FIFO
			janela_enable    : out std_logic			-- Sinal de saída: '1' quando a janela estiver totalmente preenchida e pronta
  );
end janelaCompleta;

architecture behavior of janelaCompleta is

  signal counter : unsigned(23 downto 0) := (others => '0'); -- Contador do número de pixels que já entraram na janela.
  constant max : integer := (TAM_JANELA_ESQUERDA*COLUMN_LENGTH) + (TAM_JANELA_ESQUERDA-1); -- Número de pixels que devem entrar no buffer para que a primeira janela válida possa ser processada
  
begin

  process(clock, reset)
  begin
    if (reset = '1') then
      counter     <= (others => '0');	-- Zera o contador
      janela_enable <= '0';				-- Desabilita a janela

    elsif rising_edge(clock) then
		if (fifo_en = '1') then				-- O contador só avança quando há um dado válido
			   counter <= counter + 1;		-- Incrementa o número de pixels que entraram
				if counter > to_unsigned(max - 1, counter'length) then -- O contador deve ultrapassar o limite (max - 1) para que o 'janela_enable' seja ativado no próximo ciclo
					janela_enable <= '1';	-- Janela preenchida
				else
					janela_enable <= '0';	-- Janela não preenchida 
				end if;
		end if;
    end if;
  end process;

end behavior;
