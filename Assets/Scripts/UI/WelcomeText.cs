using System;
using UnityEngine;
using System.Collections.Generic;

public class WelcomeText : MonoBehaviour
{
    [SerializeField] private AnimationCurve curve;
    [SerializeField] Material _mat;
    private float _animationTime;
    private float _animationClock;

    private void Start()
    {
        _animationTime = curve.keys[curve.length - 1].time;
        _animationClock = -1;
    }
    private void Update()
    {
        if (_animationClock < _animationTime)
        {
            _animationClock += Time.deltaTime;
            _mat.SetFloat("_DistortionAmount", curve.Evaluate(_animationClock));
        }
    }
}
