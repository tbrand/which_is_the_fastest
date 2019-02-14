from meinheld import patch

patch.patch_all()

import hug


@hug.get("/")
def index():
    return ""


@hug.get("/user/{id}")
def user_info(id):
    return str(id)


@hug.post("/user", methods=["POST"])
def user():
    return ""
