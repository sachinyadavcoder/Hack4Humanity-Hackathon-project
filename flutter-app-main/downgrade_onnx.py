import onnx
import sys

def downgrade_onnx(model_path):
    try:
        model = onnx.load(model_path)
        print(f"Original IR version: {model.ir_version}")
        
        # Downgrade IR version to 8 (which corresponds to opset 17 roughly, widely supported)
        model.ir_version = 8
        
        # Save the model back
        onnx.save(model, model_path)
        print(f"Successfully downgraded IR version to {model.ir_version}")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    downgrade_onnx("assets/models/pregnancy_risk_model.onnx")
