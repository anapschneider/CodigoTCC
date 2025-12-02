L = imread('G:\Meu Drive\Faculdade\TCC\Imagem2\cena-L.png');
R = imread('G:\Meu Drive\Faculdade\TCC\Imagem2\cena-R.png');
%L = imread('G:\Meu Drive\Faculdade\TCC\Imagem1\rochas-L.png');
%R = imread('G:\Meu Drive\Faculdade\TCC\Imagem1\rochas-R.png');

%% PETER CORKER
[D, sim, peak] = istereo(L, R, [0, 128], 15, 'metric', 'sad');
figure;
idisp(D);

figure; imagesc(D); colormap gray; colorbar;
title('Implementação Toolbox Matlab');
%% VHDL

filename = 'G:\Meu Drive\Faculdade\TCC\Imagem2\20251019-Completo15x15TESTE_128.txt';

% Lê todas as linhas como texto
fid = fopen(filename, 'r');
binLines = textscan(fid, '%s');
fclose(fid);

pixels = cellfun(@(x) bin2dec(x), binLines{1});

% Garante vetor coluna
pixels = pixels(:);

% Defina a largura da imagem (número de colunas)
largura = 960;  % <-- ajuste conforme sua imagem
altura = length(pixels) / largura;

if mod(length(pixels), largura) ~= 0
    error('Número de pixels não é múltiplo da largura escolhida.');
end

% Converte em matriz (imagem)
img = reshape(pixels, [largura, altura])';  

% Mostra a imagem em escala de cinza
figure;
imagesc(uint8(img));
colormap gray; colorbar;
title('Implementação VHDL ModelSim');

%% Resultante

% Subtração das Imagens de Disparidade (PETER CORKER - VHDL)
% Certifique-se de que D e img têm as mesmas dimensões.
% size(D) deve ser igual a size(img)
if ~isequal(size(D), size(img))
    error('As matrizes D e img (VHDL) não têm as mesmas dimensões para a subtração.');
end

% Conversão para um tipo de dado que suporte a subtração (ex: double)
D_double = double(D);
img_double = double(img);

% Realiza a subtração pixel a pixel
% O resultado representa a diferença entre os dois mapas
diferenca = D_double - img_double;

% Opcional: Calcula o valor absoluto da diferença para visualizar
% apenas a magnitude do erro, ignorando o sinal (diferença positiva/negativa)
diferenca_abs = abs(diferenca);

% Visualização da Imagem de Subtração (Diferença)
figure;
imagesc(diferenca_abs); 
% Ajusta o mapa de cores para visualizar a diferença.
colormap jet; 
colorbar;
title('Diferença entre os mapas de disparidade');

figure; surf(diferenca_abs);
shading interp;

% Cálculo das Métricas de Erro
mascara_validos = isfinite(D_double) & isfinite(img_double);
diferenca_validos = D_double(mascara_validos) - img_double(mascara_validos);

% 1. Erro Absoluto (Absoluto da diferença)
erro_abs = abs(diferenca_validos);

% 2. Erro Quadrático (Diferença ao quadrado)
erro_quad = diferenca_validos.^2;

% 3. Métrica 1: Erro Absoluto Médio (MAE - Mean Absolute Error)
% MAE = Média do Erro Absoluto.
MAE = mean(erro_abs(:));

% 4. Métrica 2: Erro Quadrático Médio (MSE - Mean Squared Error)
% MSE = Média do Erro Quadrático.
MSE = mean(erro_quad(:));

% 5. Métrica 3: Raiz do Erro Quadrático Médio (RMSE - Root Mean Squared Error)
% RMSE = Raiz quadrada do MSE.
RMSE = sqrt(MSE);

%% Exibir os resultados das métricas
fprintf('\n--- Resultados das Métricas de Erro ---\n');
fprintf('Número total de pixels: %d\n', numel(diferenca));
fprintf('Erro Absoluto Médio (MAE): %.4f pixels\n', MAE);
fprintf('Erro Quadrático Médio (MSE): %.4f\n', MSE);
fprintf('Raiz do Erro Quadrático Médio (RMSE): %.4f pixels\n', RMSE);
fprintf('--------------------------------------\n');

