from flask import Flask, jsonify, request
import os
from pathlib import Path

# Init Flask App
basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', 'my_precious_secret_key')
    DEBUG = False


class DevelopmentConfig(Config):
    DEBUG = True


def create_app(config_name: str) -> Flask:
    app = Flask(__name__)
    app.config.from_object(DevelopmentConfig)
    return app
app = create_app("dev")


# Process Function
DATA_PATH = '/ai_data/input'
OUTPUT_OBJ_PATH = '/ai_data/output'

def get_img_name(url):
    return url.split("?")[0].split("/")[-1]

def create_folder_if_not_exist(user_id):
    input_folder = "{}/{}/frames".format(DATA_PATH, user_id)
    output_folder = "{}/{}/keypoints".format(DATA_PATH, user_id)
    Path(input_folder).mkdir(parents=True, exist_ok=True)
    Path(output_folder).mkdir(parents=True, exist_ok=True)
    return input_folder, output_folder

def generate_keypoints(user_id):
    input_folder, output_folder = create_folder_if_not_exist(user_id)
    try:
        # Run 
        os.system(
            f"./build/examples/openpose/openpose.bin --display 0 --render_pose 0 --image-dir {input_folder}  -write_json {output_folder} -face -hand --net_resolution -320x320"
            # f"echo 'Run Openpose'"
        )
        return True
    except Exception as e:
        print(e)


# API Controller
@app.route('/<int:user_id>', methods=['GET'])
def gen_3d_body(user_id):
    try:
        if not user_id:
            return dict(message="Body should provide user_id"), 400
        is_generate = generate_keypoints(user_id=user_id)
        return jsonify(dict(is_generated=is_generate, user_id=user_id))
    except Exception as e:
        return dict(message="Something error", error=str(e)), 500


# Start App
if __name__ == "__main__":
    app.run(host="0.0.0.0" , port=5003) 
