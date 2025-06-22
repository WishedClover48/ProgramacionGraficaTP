using UnityEngine;

public class LavaPlaneController : MonoBehaviour
{
    [Header("Bubble Settings")]
    public GameObject lavaBubblePrefab;
    public float spawnInterval = 0.5f;
    public Vector2 scaleRange = new Vector2(0.5f, 1.5f);

    [Header("Spawn Area")]
    public Vector2 areaSize = new Vector2(5f, 5f);
    public Vector3 offset = Vector3.zero;

    private float timer = 0f;

    void Update()
    {
        if (lavaBubblePrefab == null) return;

        timer += Time.deltaTime;
        if (timer >= spawnInterval)
        {
            timer = 0f;
            SpawnBubble();
        }
    }

    void SpawnBubble()
    {
        Vector3 randomPos = new Vector3(Random.Range(-areaSize.x / 2f, areaSize.x / 2f), 0f, Random.Range(-areaSize.y / 2f, areaSize.y / 2f)
        ) + transform.position + offset;

        GameObject bubble = Instantiate(lavaBubblePrefab, randomPos, Quaternion.identity);
    }
    
    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Vector3 center = transform.position + offset;
        Vector3 size = new Vector3(areaSize.x, 0.01f, areaSize.y);
        Gizmos.DrawWireCube(center, size);
    }
}
