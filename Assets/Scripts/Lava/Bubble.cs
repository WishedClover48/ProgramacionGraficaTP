using System;
using UnityEngine;

public class Bubble : MonoBehaviour
{
    private Material m_targetMaterial;
    private readonly string m_cutoffProperty = "_Cutoff_Height";
    private readonly float m_startValue = 1f;
    private readonly float m_endValue = -1f;
    
    [Header("Pop")]
    public float duration = 1.5f;
    
    [Header("Grow")]
    public float growDuration = 1f;
    public Vector2 finalScaleRange = new Vector2(.75f, 4f);

    private float timer = 0f;
    private float growTimer = 0f;
    private float finalScale;
    private enum BubbleState { Growing, Popping }
    private BubbleState currentState = BubbleState.Growing;

    private void Start()
    {
        transform.localScale = Vector3.zero;
        
        finalScale = UnityEngine.Random.Range(finalScaleRange.x, finalScaleRange.y);
        
        m_targetMaterial = GetComponent<MeshRenderer>().material;
        m_targetMaterial.SetFloat(m_cutoffProperty, m_startValue);
    }

    void Update()
    {
        if (currentState == BubbleState.Growing)
        {
            growTimer += Time.deltaTime;
            float t = Mathf.Clamp01(growTimer / growDuration);
            float scale = Mathf.Lerp(0f, finalScale, t);
            transform.localScale = new Vector3(scale, scale, scale);

            if (t >= 1f)
            {
                currentState = BubbleState.Popping;
                timer = 0f;
            }

            return;
        }
        
        timer += Time.deltaTime;
        float popT = Mathf.Clamp01(timer / duration);
        float currentValue = Mathf.Lerp(m_startValue, m_endValue, popT);
        m_targetMaterial.SetFloat(m_cutoffProperty, currentValue);

        if (timer >= duration)
        {
            Destroy(gameObject);
        }
    }
}
