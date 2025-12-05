library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enableFifo is
  generic (COLUMN_LENGTH : integer := 10;  -- Largura/número de colunas da imagem
			  TAM_JANELA: integer := 3			 -- Fator multiplicador (tamanho da janela)
	); 

  port(clock          : in  std_logic;	-- Sinal de clock para sincronização
		 reset          : in  std_logic;	-- Sinal de reset
		 pixel_valid_in : in  std_logic;	-- Sinal de entrada que indica que um pixel válido está disponível
		 fifo_enable    : out std_logic	-- Sinal de saída que mantém o FIFO habilitado para escrita/deslocamento
  );
end enableFifo;

architecture behavior of enableFifo is

  signal counter     : unsigned(15 downto 0) := (others => '0'); 	-- Contador para rastrear os ciclos de clock decorridos após o fim dos pixels válidos
  signal hold_active : std_logic := '0';									-- Sinal de estado: '1' indica que o sistema está estendendo a habilitação
  signal max_COLUNM_LENGTH : integer := TAM_JANELA*COLUMN_LENGTH;	-- Constante que define o limite de ciclos para estender a habilitação
  
begin

  process(clock, reset)
  begin
    if (reset = '1') then
      counter     <= (others => '0');
      hold_active <= '0';
      fifo_enable <= '0';

    elsif falling_edge(clock) then	-- Ativada na borda de descida do clock
      if pixel_valid_in = '1' then 	-- Enquanto houver pixel válido, mantém ativo
        hold_active <= '1';					-- Mantém o estado ativo
        counter     <= (others => '0');	-- Zera o contador
        fifo_enable <= '1'; 					-- Habilita a escrita/deslocamento no FIFO

      else
        if hold_active = '1' then				-- Se estava ativo, começa a contar o tempo de extensão
          if counter < to_unsigned(max_COLUNM_LENGTH - 1, counter'length) then	-- Enquanto o contador não atinge o limite
            counter <= counter + 1;				-- Incrementa o contador
            fifo_enable <= '1'; 					-- Mantém o FIFO habilitado para processar os dados
          else
            -- Terminou o tempo de extensão
            hold_active <= '0';					-- Desativa o estado de hold
            fifo_enable <= '0';					-- Desabilita o FIFO
          end if;
        else
			 -- Se não há pixel válido e o estado de hold já terminou
          fifo_enable <= '0';						-- Mantém o FIFO desabilitado
        end if;
      end if;
    end if;
  end process;

end behavior;
