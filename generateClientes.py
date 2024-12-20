from faker import Faker
import random
import csv
from unidecode import unidecode
import string

fake = Faker(['pt_PT'])

# Some of this is a bit verbose now, but doing so for the sake of completion

def _toIntList(numstr, acceptX=0):
    """
    Converte string passada para lista de inteiros,
    eliminando todos os caracteres inválidos.
    Recebe string com nmero a converter.
    Segundo parÃ¢metro indica se 'X' e 'x' devem ser
    convertidos para '10' ou não.
    """
    res = []

    # converter todos os dígitos
    for i in numstr:
        if i in string.digits:
            res.append(int(i))

    # converter dígito de controlo no ISBN
    if acceptX and (numstr[-1] in 'Xx'):
        res.append(10)
    return res

def controlNIF(nif):
    """
    Verifica validade de número de contribuinte.
    Recebe string com NIF.
    """

    # verificar tamanho do número passado
    if len(nif) != 9:
        return False

    # verificar validade do carácter inicial do NIF
    if nif[0] not in "125689":
        return False

    # verificar validade
    return _valN(nif)

def _valN(num):
    """
    Algoritmo para verificar validade de NBI e NIF.
    Recebe string com número a validar.
    """

    # converter num (string) para lista de inteiros
    num = _toIntList(num)

    # computar soma de controlo
    sum = 0
    for pos, dig in enumerate(num[:-1]):
        sum += dig * (9 - pos)

    # verificar soma de controlo
    return (sum % 11 and (11 - sum % 11) % 10) == num[-1]

def get_phone_number() -> str:
    phoneNumber = fake.phone_number()
    return phoneNumber.replace("(351) ", "").replace(" ", "").replace("+351", "")

def get_client_email(fakeName):
    namesInList = fakeName.split()
    normalizedListNames = [unidecode(name.lower()) for name in namesInList]
    return f"{normalizedListNames[0]}.{normalizedListNames[-1]}@{fake.free_email_domain()}"


def create_client(id, nullNifs):
    localidade = fake.freguesia()
    distrito = fake.distrito()
    codigo_postal = fake.postcode()
    morada = fake.street_address()
    morada_completa = f"{morada}, {codigo_postal}, {localidade}, {distrito}"
    
    name = fake.name()
    email = get_client_email(name)
    nif = fake.ssn().replace("-", "")

    if nullNifs:
        nif = None
    else:
        while not controlNIF(nif):
            nif = fake.ssn().replace("-", "")
    
    return [id, morada_completa, localidade, name, email, get_phone_number(), nif]

def create_address(id):

    localidade = fake.freguesia()
    distrito = fake.distrito()
    codigo_postal = fake.postcode()
    morada = fake.street_address()
    return [id, morada, localidade, distrito, codigo_postal]

def generate_clients_csv_file(numberOfRows, nullNifs = False):
    with open('clientes30_new.csv', 'a') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['cod_cliente', 'morada', 'localidade', 'nome', 'e-mail', 'telefone', 'nif'])
        for id in range(1, numberOfRows+1):
            writer.writerow(create_client(id, nullNifs))

def generate_addresses_csv_file(numberOfRows):
    with open('addresses.csv', 'w') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['cod_morada', 'morada', 'localidade', 'distrito', 'codigo_postal'])
        for id in range(1, numberOfRows+1):
            writer.writerow(create_address(id))



# Generating clients
generate_clients_csv_file(13)
generate_clients_csv_file(17, nullNifs = True)

# Generating addresses
generate_addresses_csv_file(30)