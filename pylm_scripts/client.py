from pylm.clients import Client
import sys
import json
import codecs
import logging
import csv

client = Client(server_name='matlab_pylm',
                db_address='tcp://127.0.0.1:5559',
                logging_level=logging.DEBUG)


def json_generator(json_filename):
    client.logger.info('JSON file name: {}'.format(json_filename))
    with open(json_filename, 'rb') as f:
        reader = codecs.getreader("utf-8")
        json_loaded = json.load(reader(f))
        length = len(json_loaded)
        count = 0
        for j in json_loaded:
            count += 1
            client.logger.debug('JSON number {}'.format(count))
            client.logger.debug('JSON to send: {}'.format(j))
            yield json.dumps(j).encode('utf-8')


def json_sender(json_filename):
    client.logger.info('JSON file name: {}'.format(json_filename))
    with open(json_filename, 'rb') as f:
        reader = codecs.getreader("utf-8")
        return json.load(reader(f))


if __name__ == '__main__':
    # # EVAL
    # client.logger.info('Evaluating...')
    # json_list = json_sender(sys.argv[1])
    # results = client.eval('matlab_pylm.experiment', json.dumps(json_list).encode('utf-8'), messages=2)
    # for result in results:
    #    print(result)
    #
    # for j in json_list:
    #    result = client.eval('matlab_pylm.experiment', json.dumps(j).encode('utf-8'))
    #    print(result.decode('utf-8'))

    # JOB
    client.logger.info('Sending jobs...')
    # response_list = []

    if len(sys.argv) > 2:
        with open(sys.argv[2], 'w', newline='') as csv_file:
            metric_writer = csv.writer(csv_file, delimiter=';',
                                       quotechar='|', quoting=csv.QUOTE_MINIMAL)
            metric_list = ['Accuracy',
                           'RSME',
                           'Diversity',
                           'Kernel_diversity',
                           'Cross_runtime']
            metric_writer.writerow(['Algorithm', 'Dataset'] +
                                   metric_list +
                                   ['Runtime'])

    for response in client.job('matlab_pylm.experiment',
                               json_generator(sys.argv[1])):
        response_dict = json.loads(response.decode('utf-8'))
        client.logger.info('Processed!'.format(response_dict))
        client.logger.debug('Response: {}'.format(response_dict))

        if len(sys.argv) > 2:
            with open(sys.argv[2], 'a', newline='') as csv_file:
                metric_writer = csv.writer(csv_file, delimiter=';',
                                           quotechar='|', quoting=csv.QUOTE_MINIMAL)
                metric_list = ['Accuracy',
                               'RSME',
                               'Diversity',
                               'Kernel_diversity',
                               'Cross_runtime']
                try:
                    metric_dict = response_dict['Metrics']
                    for m in metric_list:
                        if not m.lower() in metric_dict.keys():
                            metric_dict[m.lower()] = '0.0'
                    r = [response_dict['Algorithm'],
                         response_dict['Dataset'],
                         str(metric_dict['accuracy']),
                         str(metric_dict['rsme']),
                         str(metric_dict['diversity']),
                         str(metric_dict['kernel_diversity']),
                         str(metric_dict['cross_runtime']),
                         str(response_dict['Runtime'])]
                    metric_writer.writerow(r)
                except TypeError:
                    # Error in the Pylm Worker
                    pass
