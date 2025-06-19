using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class RigidbodyFPSController : MonoBehaviour
{
    public float moveSpeed = 5f;
    public float mouseSensitivity = 2f;
    public float stepHeight = 0.3f; // Max height to step up
    public float stepSmooth = 0.1f; // Step transition speed
    public float rayDistance = 1.5f;
    public Transform cameraTransform;

    private Rigidbody _rb;
    private float verticalRotation = 0f;

    private Vector3 lowerRayOrigin = Vector3.zero;
    private Vector3 upperRayOrigin = Vector3.zero;

    void Awake()
    {
        _rb = GetComponent<Rigidbody>();
        _rb.freezeRotation = true;
    }

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void Update()
    {
        HandleMouseLook();
    }

    void FixedUpdate()
    {
        HandleMovement();
        HandleStepUp();
    }

    void HandleMouseLook()
    {
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;

        transform.Rotate(Vector3.up * mouseX);

        verticalRotation -= mouseY;
        verticalRotation = Mathf.Clamp(verticalRotation, -90f, 90f);
        cameraTransform.localRotation = Quaternion.Euler(verticalRotation, 0f, 0f);
    }

    void HandleMovement()
    {
        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");

        Vector3 move = transform.right * x + transform.forward * z;
        Vector3 targetVelocity = move * moveSpeed;

        Vector3 velocity = _rb.velocity;
        velocity.x = targetVelocity.x;
        velocity.z = targetVelocity.z;

        _rb.velocity = velocity;
    }

    void HandleStepUp()
    {
        RaycastHit hitLower;
        RaycastHit hitUpper;

        // Forward direction (horizontal, no Y)
        Vector3 direction = transform.forward;

        // Position for raycasts
        lowerRayOrigin = transform.position + Vector3.up * 0.05f;
        upperRayOrigin = transform.position + Vector3.up * (stepHeight + 0.1f);

        float rayDistance = 1.5f;

        // Lower ray hits obstacle
        if (Physics.Raycast(lowerRayOrigin, direction, out hitLower, rayDistance))
        {
            // Upper ray does NOT hit — space above is clear
            if (!Physics.Raycast(upperRayOrigin, direction, out hitUpper, rayDistance))
            {
                // Perform step by adjusting position
                _rb.position += Vector3.up * stepSmooth;
            }
        }
    }
    private void OnDrawGizmos()
    {
        Gizmos.DrawLine(lowerRayOrigin, lowerRayOrigin + transform.forward * rayDistance);
        Gizmos.DrawLine(upperRayOrigin, upperRayOrigin + transform.forward * rayDistance);
    }

}
