"""
# testing/pyside/tests/pyside_widgets.py

This is a module to test modules with Qt/PySide2 widgets and code.
The reason it is provided, is so we can test code outside of Substance Painter.
The caveat is that this module should not ever try to import APIs from the DCC
tool itself example: 'import substance_painter.ui'. Thus, some modules with
common widgets should be implemented generically with vanilla python/PySide
and also not utilize dcc apis.

Examples:

ArtTools/HOG_python/testing/pyside_widgets/*:
    - generic, no dcc specific api calls ever

ArtTools/substance/SubstancePainter/resources/python/modules/HOG_toolbar.py
    - dcc specific, that module wraps a class around a painter ui api call.
    - that module should not be accessed here, as it would fail running outside
    of painter application.  If that is a sort of test you'd like to implement,
    make a testing module in that same location: \
    -- SubstancePainter/resources/python/modules/HOG_sbsp_tests.py

ArtTools/substance/SubstancePainter/resources/python/modules/HOG_tool_actions.py
    - this module is written generically with no dcc api calls, so it can be
    imported in this module and utilized externally of painter.
    - this module creates a faux app and mainWindow
    - this module creates a stand-in vanilla toolbar
    - we test our generic toolbar buttons, icons and actions by adding them to
    that toolbar.

The purpose is to increase dev iteration time and testing; running a local in
IDE test, or external terminal test, takes far less time then booting up a dcc
application.  Of course that must be done, but it can be kicked down the road
once you have a working implementation.
"""

import logging as _logging
import sys
from typing import Union
import HOG_py.tools.HOG_site as HOG_tools_site  # noqa: F401, handles site on import
import HOG_py.globals as HOG_globals
import HOG_py.tools.icons as HOG_tools_icons
import HOG_py.tools.strings as HOG_tools_str  # noqa: F401
import HOG_py.tools.actions as HOG_tool_actions

# 3rd Party
from PySide2 import QtCore, QtGui, QtWidgets

# -------------------------------------------------------------------------
# global scope
_MODULE_NAME = "HOG_python.testing.pyside_tests.pyside_widgets"  # type: str
_LOGGER = _logging.getLogger(_MODULE_NAME)
__version__ = "0.1.CP13"
__updated__ = "2024-07-13 11:50:29"
__author__ = "jGalloway"

# this module is an entrypoint for a test so,
# create console handler and set level to debug
_console_handler = _logging.StreamHandler(sys.stdout)
_console_handler.setLevel(
    _logging.DEBUG
)  # add HOG_globals.LOG_FORMATTER to _console_handler
_console_handler.setFormatter(HOG_globals.LOG_FORMATTER)
_LOGGER.addHandler(_console_handler)  # add _console_handler to logger
_LOGGER.info(f"Starting: {_MODULE_NAME}")
_LOGGER.propagate = False


# -------------------------------------------------------------------------
class TestMainWindow(QtWidgets.QMainWindow):
    def __init__(self, parent=None):
        super().__init__(parent)

        _LOGGER.info("Creating object of class TestMainWindow")

        self.setWindowTitle("HOG-PySide2-Testing")
        self.setGeometry(300, 300, 500, 400)

        self._help_menu = None  # storage

        self._actions = []

        self.create_menu()

        self.setup_ui()

        self.setAttribute(QtCore.Qt.WA_DeleteOnClose)

    # ---------------------------------------------------------------------

    @property
    def actions(self):
        return self._actions

    @actions.setter
    def actions(self, actions):
        """
        self._actions is storage of a list of QtWidgets.QAction entities.
        Notice: there is no hard checks on the validity of list items if you
        attempt to use this property to add an entire list of references.
        is loaded with: self.child_action_list(), used in __del__
        """
        self._actions = actions
        return self._actions

    @property
    def help_menu(self, label: str = "Help") -> QtWidgets.QMenu:
        if not self._help_menu:
            self._help_menu = self.menuBar().addMenu(label)  # type: ignore
        return self._help_menu

    @help_menu.setter
    def help_menu(
        self, label: str = "Help", menu: Union[None, QtWidgets.QMenu] = None
    ) -> QtWidgets.QMenu:
        self._help_menu = menu
        if self._help_menu:
            self._help_menu.title(label)
        return self._help_menu

    @property
    def toolbar(self, name: str = "toolbar") -> QtWidgets.QToolBar:
        if not self._toolbar:
            self._toolbar = QtWidgets.QToolBar(name)  # type: ignore
        return self._toolbar

    @toolbar.setter
    def toolbar(
        self, toolbar: Union[None, QtWidgets.QToolBar] = None
    ) -> QtWidgets.QToolBar:
        self._toolbar = toolbar
        return self._toolbar

    # ---------------------------------------------------------------------
    def create_menu(self):
        self._test_menu = self.menuBar().addMenu("TestMenu")  # type: ignore

        # Exit QAction on hotkey
        exit_str = "Exit"
        self._action_exit = QtWidgets.QAction(exit_str, self)  # type: ignore
        self._action_exit.setShortcut("Ctrl+Q")
        self._action_exit.triggered.connect(self.close)  # type: ignore

        # basic menubar File > Exit event
        self._test_menu.addAction(exit_str, self.close)  # type: ignore

        self.setup_help_menu()

        return self._test_menu

    # ---------------------------------------------------------------------
    def setup_help_menu(self):
        self._actions.append(
            HOG_tool_actions.action_add_HOG_arttools_help(self.help_menu)
        )
        self._actions.append(HOG_tool_actions.action_add_HOG_jira_bug(self.help_menu))

    # ---------------------------------------------------------------------
    def setup_ui(self):
        # main widget
        self._central_widget = QtWidgets.QWidget(self)  # type: ignore
        self.setCentralWidget(self._central_widget)

        self.toolbar = QtWidgets.QToolBar("test_toolbar", parent=self)  # type: ignore
        self.toolbar.setIconSize(QtCore.QSize(32, 32))  # type: ignore
        self.toolbar.setAttribute(QtCore.Qt.WA_DeleteOnClose)
        self.addToolBar(self.toolbar)

        # layout initialize
        self._global_layout = QtWidgets.QVBoxLayout()  # type: ignore
        self._central_widget.setLayout(self._global_layout)

        # Add Widgets
        self.spinbox = QtWidgets.QSpinBox()  # type: ignore
        self.spinbox.setValue(30)
        self._global_form = QtWidgets.QFormLayout()  # type: ignore
        self._global_form.addRow("Parameter", self.spinbox)

        # create a button
        self.button = QtWidgets.QPushButton(
            icon=QtGui.QIcon(str(HOG_tools_icons.HOG_ICON_PATH)), text="Execute", parent=self  # type: ignore
        )  # type: ignore
        self.button.setStatusTip("This is a test button")
        self.button.clicked.connect(self.on_button_click)  # type: ignore

        self.button_msgbox = QtWidgets.QPushButton(
            icon=QtGui.QIcon(str(HOG_tools_icons.HOG_ICON_PATH)), text="HOG Message Box", parent=self  # type: ignore
        )  # type: ignore
        self.button_msgbox.setStatusTip("Open a HOG message box")
        self.button_msgbox.clicked.connect(self.on_messagebox_button_click)  # type: ignore

        self.toolbar_teardown = QtWidgets.QPushButton(
            icon=QtGui.QIcon(str(HOG_tools_icons.HOG_ICON_PATH)), text="Teardown Toolbar", parent=self  # type: ignore
        )  # type: ignore
        self.toolbar_teardown.setStatusTip("Teardown Menu and Toolbox")
        self.toolbar_teardown.clicked.connect(self.teardown)  # type: ignore

        # global layout setting
        self._global_layout.addLayout(self._global_form)
        self._global_layout.addWidget(self.button)
        self._global_layout.addWidget(self.button_msgbox)
        self._global_layout.addWidget(self.toolbar_teardown)

        self.add_toolbar_HOG_default_actions()

        self.setStatusBar(QtWidgets.QStatusBar(self))  # type: ignore

        self.show()

    # ---------------------------------------------------------------------
    def add_toolbar_HOG_default_actions(self):
        # TOOLBAR
        # test opening the help url
        HOG_tool_actions.action_add_HOG_arttools_help(self.toolbar)

        # test only, generally don't use these in production code
        HOG_tool_actions._action_explore_default_file_directory(__file__, self.toolbar)
        HOG_tool_actions._action_my_custom_explorer_method(self.toolbar)

        # do use this in the production code for toolbar
        HOG_tool_actions.action_start_painter_vscode(self.toolbar)

    # ---------------------------------------------------------------------
    def on_button_click(self):
        message = "Execute button Clicked"
        print(message)
        _LOGGER.info(message)

    # ---------------------------------------------------------------------
    def on_messagebox_button_click(self):
        from HOG_py.lib.HOG_error.HOG_messageBox import HOG_messageBox

        init_message = "Opening a HOG message box"
        print(init_message)
        _LOGGER.info(init_message)

        result = None
        try:
            result = HOG_messageBox(
                messageType="question",
                mainText="This is a HOG message box question",
                informativeText="This is informative text.",
                detailedText="This is detailed text.",
                parent=self,
                wait=30,
            )
        except Exception as e:
            _LOGGER.exception(e)

        if result == QtWidgets.QMessageBox.Yes:
            result_message = f"The question box result is {result} == Yes (True)"
        elif result == QtWidgets.QMessageBox.No:
            result_message = "The question box result was: No (False)"
        else:
            result_message = "unknown result"

        _LOGGER.info(result_message)

    # ---------------------------------------------------------------------
    def toolbar_child_action_list(self):
        self.actions = self.toolbar.findChildren(QtWidgets.QAction)  # type: ignore
        return self.actions

    # ---------------------------------------------------------------------
    def teardown(self):
        """teardown and remove internals"""
        # remember that self is MainWindow
        for action in self.toolbar_child_action_list():
            _LOGGER.info(f"Attempting to remove action: {action.objectName()}")
            if action.objectName() != "":
                try:
                    # action.triggered.disconnect()
                    action.deleteLater()
                    del action
                except Exception as e:
                    _LOGGER.exception(e)

        self.toolbar.setParent(None)
        self.toolbar.close()
        self.toolbar.deleteLater()
        self.toolbar = None  # type: ignore

    # ---------------------------------------------------------------------
    def closeEvent(self, event):
        """Event which is run when window closes"""
        self.teardown()
        self.toolbar = None  # type: ignore
        return


# -------------------------------------------------------------------------
if __name__ == "__main__":
    """Run this file as main"""

    _logging.basicConfig(
        level=_logging.DEBUG,
        datefmt=HOG_globals.DATE_FORMAT,
        format=HOG_globals.FRMT_LOG_LONG,
    )
    __LOGGER = _logging.getLogger(f"{_MODULE_NAME}.__main__")

    import sys

    app = QtWidgets.QApplication(sys.argv)  # type: ignore

    try:
        mainWin = TestMainWindow()  # type: ignore
    except Exception as e:
        __LOGGER.exception(e)

    sys.exit(app.exec_())
