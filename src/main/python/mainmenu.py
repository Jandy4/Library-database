from PyQt5 import uic, QtWidgets, QtCore
from PyQt5.QtWidgets import QHeaderView, QStackedLayout, QMainWindow, QWidget, QTabWidget, QPushButton, QLabel, QTableView, QShortcut
from PyQt5.QtCore import Qt, QDate
from PyQt5.QtGui import QKeySequence
from fbs_runtime.application_context import cached_property
from fbs_runtime.application_context.PyQt5 import ApplicationContext
import sys
import os
import sqlite3
from datetime import date

'''
TODO 
implement ui for students tab - check
implement ui for borrows - check
create student add menu
create borrow creation menu
implement import excel tab
implement database selection
database backup
create new db from template
edit book
edit borrow
edit student
'''


class OLDIContext(ApplicationContext):

    @cached_property
    def window(self):
        self.ui = self.get_resource(r'UIs\main.ui')
        self.books_ui = self.get_resource(r'UIs\books.ui')
        self.students_ui = self.get_resource(r'UIs\students.ui')
        self.borrows_ui = self.get_resource(r'UIs\borrows.ui')
        self.cur = self.db_connect
        return MainWindow(self.ui, self.books_ui, self.students_ui, self.borrows_ui, self.cur)

    @cached_property
    def db_connect(self):
        try:
            con = sqlite3.connect(self.get_resource('DBs\Biblioteca.db'))
        except Error as e:
            print(e)
        return con.cursor()
        
    @cached_property
    def run_app(self):
        self.window.show()
        return self.app.exec_

class MainWindow(QMainWindow):

    def __init__(self, ui, books_ui, students_ui, borrows_ui, cur):
        super(MainWindow, self).__init__()
        uic.loadUi(ui, self)

        self.setWindowTitle('OLDI')
        
        self.cur = cur
        self.books_ui = books_ui
        self.students_ui = students_ui
        self.borrows_ui = borrows_ui

        self.pagelayout = self.centralwidget.layout()

        self.tabs_layout = QtWidgets.QStackedLayout()

        self.pagelayout.addLayout(self.tabs_layout)

        self.books_btn.pressed.connect(lambda: self.tabs_layout.setCurrentIndex(0))
        self.students_btn.pressed.connect(lambda: self.tabs_layout.setCurrentIndex(1))
        self.borrows_btn.pressed.connect(lambda: self.tabs_layout.setCurrentIndex(2))

        self.tabs_layout.addWidget(Books(self.books_ui, self.cur))
        self.tabs_layout.addWidget(Students(self.students_ui, self.cur))
        self.tabs_layout.addWidget(Borrows(self.borrows_ui, self.cur))

        

class TableModel(QtCore.QAbstractTableModel):

    def __init__(self, data):
        super(TableModel, self).__init__()
        self._data = data

    def data(self, index, role):
        if role == Qt.DisplayRole:
            return self._data[index.row()][index.column()]

    def rowCount(self, index):
        return len(self._data)

    def columnCount(self, index):
        if self._data == []:
            return 0
        return len(self._data[0])

 
class Books(QWidget):
    def __init__(self, ui, cur):
        super(Books, self).__init__()
        uic.loadUi(ui, self)

        self.cur = cur
        cur.execute("SELECT * FROM books")
        data = cur.fetchall()

        self.model = TableModel(data)
        self.tableView.setModel(self.model)

        self.header = QHeaderView(Qt.Horizontal)
        self.header.setSectionResizeMode(3) #resize to column size

        self.tableView.setHorizontalHeader(self.header)
        
        for genre in self.get_genres():
            self.genre_combobox.addItem(str(genre[0]) + ' ' + genre[1])
        self.genre_combobox.setCurrentIndex(8)

        shortcut = QShortcut(QKeySequence("Return"), self)
        shortcut.activated.connect(lambda: self.query())
        self.search_button.pressed.connect(lambda: self.query())

    def query(self):
        index = self.genre_combobox.currentIndex()
        self.cur.execute("SELECT * FROM books WHERE title LIKE ? AND author LIKE ? AND genre_id = ?",('%' + self.title_box.text() + '%' , '%' + self.name_box.text() + '%', index))
        data = self.cur.fetchall()

        self.model = TableModel(data)
        self.tableView.setModel(self.model)

    def get_genres(self):
        self.cur.execute('SELECT * from genres')
        return self.cur.fetchall()

class Students(QWidget):

    def __init__(self, ui, cur):
        super(Students, self).__init__()
        self.cur = cur
        
        uic.loadUi(ui, self)
        self.cur.execute("SELECT * FROM students")
        data = cur.fetchall()

        self.model = TableModel(data)
        self.tableView.setModel(self.model)

        self.header = QHeaderView(Qt.Horizontal)
        self.header.setSectionResizeMode(3)
        self.tableView.setHorizontalHeader(self.header)

        shortcut = QShortcut(QKeySequence("Return"), self)
        shortcut.activated.connect(lambda: self.query())
        self.search_button.pressed.connect(lambda: self.query())
    
    def query(self):
        self.cur.execute("SELECT * FROM students WHERE first_name LIKE ? AND last_name LIKE ? AND phone LIKE ?", ('%' + self.firstname_box.text() + '%', '%' + self.lastname_box.text() + '%', '%' + self.phone_box.text() + '%'))
        data = self.cur.fetchall()
        self.model = TableModel(data)
        self.tableView.setModel(self.model)

class Borrows(QWidget):

    def __init__(self, ui, cur):
        super(Borrows, self).__init__()
        self.cur = cur

        uic.loadUi(ui, self)
        self.cur.execute("SELECT * FROM borrows")
        data = cur.fetchall()

        self.model = TableModel(data)
        self.tableView.setModel(self.model)

        self.header = QHeaderView(Qt.Horizontal)
        self.header.setSectionResizeMode(3)
        self.tableView.setHorizontalHeader(self.header)

        shortcut = QShortcut(QKeySequence("Return"), self)
        shortcut.activated.connect(lambda: self.query())
        self.search_button.pressed.connect(lambda: self.query())

        self.date_edit.setDisplayFormat('yyyy-MM-dd')
        today_date = QDate.fromString(str(date.today()), 'yyyy-MM-dd')
        self.date_edit.setDate(today_date)
    
    def query(self):
        student_id = self.student_box.text()
        book_id = self.book_box.text()
        date = '%' + str(self.date_edit.date().toPyDate()) + '%'

        if self.check_box.isChecked():
            if student_id == '' and book_id == '':
                self.cur.execute("SELECT * FROM borrows WHERE date LIKE ?", (date,))
            elif student_id == '':
                self.cur.execute("SELECT * FROM borrows WHERE book_id = ? AND date LIKE ?", (book_id, date))
            elif book_id == '':
                self.cur.execute("SELECT * FROM borrows WHERE student_id = ? AND date LIKE ?", (student_id, date))
        
        else:
            if student_id == '' and book_id == '':
                self.cur.execute("SELECT * FROM borrows")
            elif student_id == '':
                self.cur.execute("SELECT * FROM borrows WHERE book_id = ?", book_id)
            elif book_id == '':
                self.cur.execute("SELECT * FROM borrows WHERE student_id = ?", student_id)

        data = self.cur.fetchall()
        self.model = TableModel(data)
        self.tableView.setModel(self.model)



        

if __name__ == '__main__':  
    appctxt = OLDIContext()
    appctxt.run_app()