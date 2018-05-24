import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

class postgresql(object):
    """
    Class keeping all things related to postgreSQL
    """

    def __init__(self,conn):
        """
        initializing the class with connection parameters and establishing a connection if possible
        """
        self.__conn = conn
        try:
            self.__conn = psycopg2.connect(self.__conn)
            self.__conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        except:
            raise psycopg2.InterfaceError('Could not connect to database!')

    def execute(self,exc):
        """
        method to execute sql querys via the connection
        """
        self.__exc = exc
        self.__cur = self.__conn.cursor()
        self.__cur.execute(exc)
        #try:
        #    self.__cur.execute(exc)
        #except:
        #    raise psycopg2.DatabaseError('Could not execute statement!')
        try:
            return self.__cur.fetchall()
        except:
            return None

    ##############################################
    # Deconstruction                             #
    ##############################################
    def closed(self):
        """
        check if the connection is closed
        """
        return bool(self.__conn.closed)

    def close(self):
        """
        close the connection
        """
        try:
            self.__cur.close()
        except:
            pass
        try:
            self.__conn.close()
        except:
            pass

    def __del__(self):
        """
        delete instance of class after connection is closed
        """
        if not self.closed():
            self.close()
