import package


aClass = package.DefinedClass(3, 4, param1="a string")


@package.decorate
def SubFib(startNumber, endNumber):
    for cur in range(endNumber):
        if cur > endNumber:
            return
        if cur >= startNumber:
            yield cur

for ii in SubFib(10, 200):
    if aClass.class_method():
        print ii


class ThisClass(object):
    def __init__(self, *args, **kwargs):
        '''
        Block comments
        '''
        self.this = "that"

    def is_this_that(self):
        return True if self.this == "that" else False
