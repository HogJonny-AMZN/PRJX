"""
HOG_substance_testing/custom_tree_example.py
A module that builds a simple TreeView (used as reference)
"""

import sys
from PySide2 import QtCore, QtGui, QtWidgets

# -------------------------------------------------------------------------
__version__ = "0.1.CP13"
__updated__ = "2024-07-10 11:25:33"
__author__ = "jGalloway"


# -------------------------------------------------------------------------------
# my test data
class MyDataModel:
    def __init__(self, txt, parent=None):
        self.txt = txt
        self.parent = parent
        self.child = []
        self.icon = None
        self.index = None

    # ---------------------------------------------------------------------------
    def position(self):
        position = 0
        if self.parent is not None:
            count = 0
            children = self.parent.child
            for child in children:
                if child == self:
                    position = count
                    break
                count += 1
        return position

    # ---------------------------------------------------------------------------
    # test initialization
    @staticmethod
    def init():
        root = MyDataModel("root")
        for i in range(0, 2):
            child1 = MyDataModel("child %i" % (i), root)
            root.child.append(child1)
            for x in range(0, 2):
                child2 = MyDataModel("child %i %i" % (i, x), child1)
                child1.child.append(child2)

        return root


# -------------------------------------------------------------------------------
class TreeModel(QtCore.QAbstractItemModel):
    # ---------------------------------------------------------------------------
    def __init__(self, tree):
        super(TreeModel, self).__init__()
        self.__tree = tree
        self.__current = tree

    # ---------------------------------------------------------------------------
    def flags(self, index):
        flag = QtCore.Qt.ItemIsEnabled
        if index.isValid():
            flag |= (
                QtCore.Qt.ItemIsSelectable  # type: ignore
                | QtCore.Qt.ItemIsUserCheckable  # pylint: ignore
                | QtCore.Qt.ItemIsEditable  # pylint: ignore
                | QtCore.Qt.ItemIsDragEnabled  # pylint: ignore
                | QtCore.Qt.ItemIsDropEnabled  # pylint: ignore
            )  # pylint: ignore
        return flag

    # ---------------------------------------------------------------------------
    def index(self, row, column, parent=QtCore.QModelIndex()):
        node = QtCore.QModelIndex()
        if parent.isValid():
            nodeS = parent.internalPointer()
            nodeX = nodeS.child[row]  # type: ignore
            node = self.__createIndex(row, column, nodeX)
        else:
            node = self.__createIndex(row, column, self.__tree)
        return node

    # ---------------------------------------------------------------------------
    def parent(self, index):
        node = QtCore.QModelIndex()
        if index.isValid():
            nodeS = index.internalPointer()
            parent = nodeS.parent
            if parent is not None:
                node = self.__createIndex(parent.position(), 0, parent)
        return node

    # ---------------------------------------------------------------------------
    def rowCount(self, index=QtCore.QModelIndex()):
        count = 1
        node = index.internalPointer()
        if node is not None:
            count = len(node.child)
        return count

    # ---------------------------------------------------------------------------
    def columnCount(self, index=QtCore.QModelIndex()):
        return 1

    # ---------------------------------------------------------------------------
    def data(self, index, role=QtCore.Qt.DisplayRole):
        data = None
        if role == QtCore.Qt.DisplayRole or role == QtCore.Qt.EditRole:
            node = index.internalPointer()
            data = node.txt

        if role == QtCore.Qt.ToolTipRole:
            node = index.internalPointer()
            data = "ToolTip " + node.txt

        if role == QtCore.Qt.DecorationRole:
            data = QtGui.QIcon("icon.png")  # type: ignore
        return data

    # ---------------------------------------------------------------------------
    def setData(self, index, value, role=QtCore.Qt.DisplayRole):
        result = True
        if role == QtCore.Qt.EditRole and value != "":
            node = index.internalPointer()
            node.text = value
            result = True
        return result

    # ---------------------------------------------------------------------------
    def __createIndex(self, row, column, node):
        if node.index is None:
            index = self.createIndex(row, column, node)
            node.index = index
            icon = QtGui.QIcon("icon.png")  # type: ignore
            b = self.setData(index, icon, QtCore.Qt.DecorationRole)
            b = self.setData(index, "ToolTip " + node.txt, QtCore.Qt.ToolTipRole)
        return node.index


# -------------------------------------------------------------------------------
class TreeView(QtWidgets.QTreeView):
    # ---------------------------------------------------------------------------
    def __init__(self, model, parent=None):
        super(TreeView, self).__init__(parent)
        self.__model = model
        self.setModel(model)

        self.setCurrentIndex(self.__model.index(0, 0))
        return


# -------------------------------------------------------------------------------
class MyTree(QtWidgets.QMainWindow):
    def __init__(self, parent=None):
        super(MyTree, self).__init__(parent)

        data = MyDataModel.init()
        treeModel = TreeModel(data)  # type: ignore
        treeView = TreeView(treeModel)  # type: ignore

        self.setCentralWidget(treeView)


# -------------------------------------------------------------------------------
def main():
    app = QtWidgets.QApplication(sys.argv)  # type: ignore
    form = MyTree()  # type: ignore
    form.show()
    app.exec_()


if __name__ == "__main__":
    main()
