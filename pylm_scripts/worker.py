from pylm.servers import Worker
import matlab.engine
import logging
import json
import sys
import re


class MyWorker(Worker):
    def experiment(self, argument):
        # Start engine
        eng = matlab.engine.start_matlab()
        eng.maxNumCompThreads(1)
        # Expecting a string
        argument_str = argument.decode("utf-8")
        result = eng.Experiment_json(argument_str)
        # Stop engine
        eng.quit()
        eng = None
        # Return result
        return result.encode('utf-8')


worker = MyWorker('matlab_pylm',
                  db_address='tcp://127.0.0.1:5559',
                  log_level=logging.DEBUG)

if __name__ == '__main__':
    worker.start()
