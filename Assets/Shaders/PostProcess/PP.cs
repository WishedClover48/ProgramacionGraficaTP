using System;
using UnityEngine;

public class PP : MonoBehaviour
{
    public Shader shader;
    private Material _mat;
    public float intensity;
    //public float step;

    private void Start()
    {
        _mat = new Material(shader);
    }

    private void Update()
    {
        _mat.SetFloat("_Intensity", intensity);
        //_mat.SetFloat("_Step", step);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _mat);
    }
}
