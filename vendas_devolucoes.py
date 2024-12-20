import random
from datetime import datetime, timedelta
import pandas as pd

# Parâmetros
num_clientes = 30
num_compras = 75
num_devolucoes = 14  # Número aceitável de devoluções

# Listas de dados
cod_clientes = list(range(1, num_clientes+1))
cod_produtos = [
    1234, 1235, 1236, 1237, 1238, 1239, 1240, 1241, 1242, 1243, 1244, 1245,
    1246, 1247, 1248, 1249, 1250, 1251, 1252, 1253, 1254, 1255, 1256
]
precos_produtos = {
    1234: 1.75, 1235: 2.25, 1236: 2.25, 1237: 2.45, 1238: 2.45, 1239: 2.45,
    1240: 2.99, 1241: 2.99, 1242: 2.99, 1243: 1.55, 1244: 2.45, 1245: 2.45,
    1246: 2.85, 1247: 2.99, 1248: 2.99, 1249: 2.99, 1250: 3.45, 1251: 3.45,
    1252: 2.45, 1253: 2.75, 1254: 2.99, 1255: 2.99, 1256: 2.99
}
status_pedido_opcoes = ['Pendente', 'Enviado', 'Entregue', 'Entregue', 'Cancelado', 'Pendente', 'Pendente']

# Função para gerar datas aleatórias
def gerar_data():
    inicio = datetime(2023, 1, 1)
    fim = datetime(2024, 12, 1)
    delta = fim - inicio
    dias_aleatorios = random.randint(0, delta.days)
    return inicio + timedelta(days=dias_aleatorios)

# Geração de compras
compras = []
for i in range(1, num_compras+1):
    cod_venda = f'V{str(i).zfill(4)}'
    cod_cliente = random.choice(cod_clientes)
    cod_prod = random.choice(cod_produtos)
    qtd = random.randint(1, 10)
    preco_venda = precos_produtos[cod_prod] * qtd
    data = gerar_data().strftime('%Y-%m-%d')
    status_pedido = random.choice(status_pedido_opcoes)

    compras.append((cod_venda, cod_cliente, cod_prod, qtd, round(preco_venda, 2), data, status_pedido))

# Criar DataFrame e exportar para CSV
compras_df = pd.DataFrame(compras, columns=['cod_venda', 'cod_cliente', 'cod_prod', 'qtd', 'preco_venda', 'data', 'status_pedido'])
compras_df.to_csv('compras_geradas.csv', index=False)

# Geração de devoluções
reembolsos = []
compras_entregues = compras_df[compras_df['status_pedido'] == 'Entregue']

# Selecionar clientes para fazer reembolso
clientes_com_reembolso = random.sample(compras_entregues['cod_cliente'].unique().tolist(), 
                                      min(20, len(compras_entregues['cod_cliente'].unique())))
compras_com_devolucao = compras_entregues[compras_entregues['cod_cliente'].isin(clientes_com_reembolso)]

# Garantir que o número de devoluções não exceda o número de compras entregues
devolucoes_selecionadas = compras_com_devolucao.sample(n=min(num_devolucoes, len(compras_com_devolucao)))

# Gerar códigos de reembolso sequenciais
contador_reembolsos = 1  # Inicia o contador de códigos de reembolso em 1

for _, devolucao in devolucoes_selecionadas.iterrows():
    cod_reembolso = f'R{str(contador_reembolsos).zfill(4)}'  # Código sequencial
    cod_cliente = devolucao['cod_cliente']
    cod_venda = devolucao['cod_venda']
    cod_prod = devolucao['cod_prod']
    valor_reemb = devolucao['preco_venda']
    
    # Ajustar a data de reembolso para no máximo 30 dias após a data da compra
    data_compra = datetime.strptime(devolucao['data'], '%Y-%m-%d')
    delta_dias = random.randint(0, 30)  # Número de dias entre a compra e a devolução (no máximo 30 dias)
    data_reem = (data_compra + timedelta(days=delta_dias)).strftime('%Y-%m-%d')
    
    reembolsos.append((cod_reembolso, cod_cliente, cod_venda, cod_prod, round(valor_reemb, 2), data_reem))
    contador_reembolsos += 1  # Incrementa o contador

# Criar DataFrame de reembolsos e exportar para CSV
reembolsos_df = pd.DataFrame(reembolsos, columns=['cod_reembolso', 'cod_cliente', 'cod_venda', 'cod_prod', 'valor_reemb', 'data_reem'])
reembolsos_df.to_csv('reembolsos_gerados.csv', index=False)


