from pylm.servers import Worker
import matlab.engine
import logging
import json
import sys
import re


class MyWorker(Worker):
    eng = matlab.engine.start_matlab()
    eng.maxNumCompThreads(1)

    def experiment(self, argument):
        # Expecting a string
        argument_str = argument.decode("utf-8")
        result = self.eng.Experiment_json(argument_str)
        return result.encode('utf-8')

    def foo(self, message):
        json_file = json.loads(message.decode("utf-8"))
        report_name = json_file['Report']['report_name']
        print('This works!')
        return report_name.encode('utf-8')


worker = MyWorker('matlab_pylm',
                  db_address='tcp://127.0.0.1:5559',
                  log_level=logging.DEBUG)

if __name__ == '__main__':
    worker.start()
