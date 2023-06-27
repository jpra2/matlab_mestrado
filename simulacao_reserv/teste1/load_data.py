import numpy as np
import pandas as pd
import os

#365 730  1095  1460 1825 2190 2555 2920 3285 3650 4015 4380 4745 5110

folder = 'dados'
file_name_tss = 'ITEMP.TSS'
file_name_arr = 'ITEMP.ARR'

name_column = '-'
# name_column = 'base24'
file_name_csv_to_save = name_column + '.csv'
file_name_arr_to_save = name_column + '_arr.csv'

arr_files = ['base_arr.csv', 'base2_arr.csv', 'base3_c_arr.csv', 'base3_c3_col_arr.csv', 'base12_arr.csv', 
             'base13_arr.csv', 'base14_arr.csv','base15_arr.csv', 'base16_arr.csv', 'base17_arr.csv', 
             'base18_arr.csv', 'base19_arr.csv', 'base20_arr.csv', 'base21_arr.csv',
             'base22_arr.csv', 'base23_arr.csv', 'base24_arr.csv']

file_names = ['base.csv', 'base2.csv', 'base3.csv', 'base4.csv', 'base5.csv', 'base6.csv', 'base7.csv',
              'base8.csv', 'base3_c.csv', 'base3_c2.csv', 'base3_c3_col.csv', 'base10.csv', 'base11.csv',
              'base12.csv', 'base13.csv', 'base14.csv', 'base15.csv', 'base16.csv', 'base17.csv',
              'base18.csv', 'base19.csv', 'base20.csv', 'base21.csv', 'base22.csv', 'base23.csv',
              'base24.csv']

names_column = ['base', 'base2', 'base3', 'base4', 'base5', 'base6', 'base7', 'base8' 'base3_c',
                'base3_c2', 'base3_c3_col', 'base10', 'base11', 'base12', 'base13', 'base14',
                'base15', 'base16', 'base17', 'base18', 'base19', 'base20', 'base21', 'base22', 'base23',
                'base24']

description = {
    'base': 'caso sem alteracao',
    'base2': 'alterou o tempo total de simulacao para 1460 dias',
    'base3_c': 'colocou 4 pocos injetores de agua nas quinas com 80 de vazao de injecao depois de 365 dias e taxa de producao total de 150.',
    'base3_c2': 'aumentou o tempo de simulacao',
    'base3_c3_col': 'aumentou o tempo de simulacao denovo (colocar)',
    'base3': 'colocou 3 pocos injetores de agua nas quinas com 100 de vazao de injecao depois de 365 dias',
    'base4': 'base3 com alteracao da vazao de oleo de producao para zero e vazao total de producao de 300',
    'base5': 'base4 com tempo maximo de simulacao de 5110',
    'base6': 'base5 com alteracao da taxa de producao maxima pra 410 em 2920 dias',
    'base7': 'base6 com alteracao da taxa de producao maxima para 100 em 730 dias',
    'base8': 'base7 alterado - taxa de producao intermediaria',
    'base10': 'caso base com tempo total de 1460 dias e localizacao do poco produtor em 9 9 1 (foi ate 520 dias)',
    'base11': 'caso 10 com 1 poco injetor em 1 1 1 com vazao de 600 (foi ate 1460 dias)',
    'base12': 'caso 10 com alteracoes na producao',
    'base13': 'caso 12 com delta time max = 30 (normal = 15)',
    'base14': 'caso 12 com delta time max = 10',
    'base15': 'caso 12 com delta time max = 40',
    'base16': 'caso 14 com modificacao nas datas das taxas de producao: em 2920 taxa de producao total de 350',
    'base17': 'caso 16 com modificacao da taxa total de producao em 2920 dias para 310 ',
    'base18': 'caso base3_c3_col com refinamento da malha em x e y',
    'base19': 'caso base12 com refinamento da malha em x e y',
    'base20': 'caso base19 com alteracao da taxa de producao total para 310 em 1825 dias',
    'base21': 'caso base20 com campo de permeabilidade heterogeneo',
    'base22': 'caso base21 com alteracao das taxas de producao',
    'base23': 'caso base14 com alteracao da pressao maxima para 8000',
    'base24': 'caso base20 (1/4) com 27x27 volumes e alteracao na producao e injecao'
}

def load_from_tss_and_save(file_name, name_col, to_save_name):
    datas_name  = ['time_step', 'time_days', 'iter', 'pavg_psia', 'oil_tx_stb_p_day', 'cum_oil_Mstb', 'wat_tx_stb_p_day', 'cum_w_Mstb', 'wor_stb_stb', 'gas_tx_Mcf_p_day', 'cum_gas_Mmcf', 'gor_stf_stb', 'r1', 'r2', 'r3', 'r4', 'r5']
    datas = []

    with open(file_name, 'r') as f:
        for line in f:
            line_data = line.strip().split(' ')
            if len(line_data) < 3:
                continue

            try:
                value = int(line_data[0])
            except ValueError:
                continue

            line_data = [float(i) for i in line_data if i != '']
            datas.append(line_data)

    datas = np.array(datas)
    datas = datas[:, 0:12]

    df = pd.DataFrame(columns=datas_name[0:12], data=datas)
    df = df.astype({'time_step': int, 'iter': int})
    df['case'] = [name_col] * df.shape[0]
    save_df(df, to_save_name)

def save_df(df, file_name):

    path = os.path.join(folder, file_name)
    df.to_csv(path, index=False)

def load_df(file_name):
    path = os.path.join(folder, file_name)
    df = pd.read_csv(path)
    return df

def load_arr_file_and_save(file_name, to_save_name, case_name):
    read_data = False
    day = 0
    count_to_read = 1e10
    data_names = ['P', 'So', 'Sw', 'Sg', 'day']
    all_data = []

    with open(file_name, 'r') as f:
        count = 0
        for line in f:
            count += 1
            line_data = line.strip().split(' ')

            if line_data[1] == 'DAYS':
                day = float(line_data[0])
                count_to_read = count + 2
                continue

            if count >= count_to_read:
                data = [float(i) for i in line_data if i != '']
                data = data[0:4]
                data.append(day)
                all_data.append(data)

    all_data = np.array(all_data)
    df = pd.DataFrame(columns=data_names, data=all_data)
    df['case'] = [case_name] * df.shape[0]
    df = df.astype({'day': int})
    save_df(df, to_save_name)

def create_gif(case):
    
    
    import contextlib
    from PIL import Image

    folder = 'data_cases'
    folder = os.path.join(folder, case)

    gif_path = os.path.join(folder, 'gifs')

    # filepaths
    fp_in = gif_path
    fp_out = os.path.join(folder, 'movie_sw.gif')

    # use exit stack to automatically close opened images
    with contextlib.ExitStack() as stack:
        all_dirs = os.listdir(fp_in)
        all_dirs = [os.path.join(fp_in, i) for i in all_dirs]

        # lazily load images
        imgs = (stack.enter_context(Image.open(f))
                for f in sorted(all_dirs))

        # extract  first image from iterator
        img = next(imgs)

        # https://pillow.readthedocs.io/en/stable/handbook/image-file-formats.html#gif
        img.save(fp=fp_out, format='GIF', append_images=imgs,
                save_all=True, duration=200, loop=0)

# load_from_tss_and_save(file_name_tss, name_column, file_name_csv_to_save)
# load_arr_file_and_save(file_name_arr, file_name_arr_to_save, name_column)

# # cases = ['base3_c3_col', 'base12', 'base18', 'base20']
# cases = ['base22']
# for case in cases:
#     create_gif(case)
